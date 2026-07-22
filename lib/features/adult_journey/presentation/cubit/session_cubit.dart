import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:talia/features/auth/presentation/cubit/auth_state.dart';
import 'package:talia/features/memorization_engine/domain/engine/session_engine.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/repositories/session_repository.dart';
import 'package:talia/features/memorization_engine/domain/usecases/advance_session_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/complete_session_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/evaluate_recitation_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_active_session_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/start_session_use_case.dart';
import 'package:talia/features/adult_journey/presentation/cubit/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final StartSessionUseCase _startSession;
  final GetActiveSessionUseCase _getActiveSession;
  final AdvanceSessionUseCase _advanceSession;
  final EvaluateRecitationUseCase _evaluateRecitation;
  final CompleteSessionUseCase _completeSessionUseCase;
  final SessionEngine _sessionEngine;
  final SessionRepository _sessionRepository;
  final AuthCubit _authCubit;

  SessionCubit({
    required this._startSession,
    required this._getActiveSession,
    required this._advanceSession,
    required this._evaluateRecitation,
    required CompleteSessionUseCase completeSession,
    required this._sessionEngine,
    required this._sessionRepository,
    required this._authCubit,
  })  : _completeSessionUseCase = completeSession,
        super(const SessionState());

  String get _userId {
    final authState = _authCubit.state;
    return authState is Authenticated ? authState.user.id : 'guest';
  }

  Future<void> startSession(int surah, int startAyah, int endAyah) async {
    emit(state.copyWith(status: SessionCubitStatus.loading));
    final result = await _startSession(
      userId: _userId,
      surahNumber: surah,
      startAyah: startAyah,
      endAyah: endAyah,
    );
    result.fold(
      (l) => emit(
        state.copyWith(
          status: SessionCubitStatus.error,
          errorMessage: l.message,
        ),
      ),
      (session) => emit(
        state.copyWith(
          status: SessionCubitStatus.active,
          session: session,
          currentAyahIndex:
              _sessionEngine.nextActionableAyahIndex(session) ?? 0,
        ),
      ),
    );
  }

  Future<void> resumeSession() async {
    emit(state.copyWith(status: SessionCubitStatus.loading));
    final result = await _getActiveSession(_userId);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: SessionCubitStatus.error,
          errorMessage: l.message,
        ),
      ),
      (session) {
        if (session != null) {
          emit(
            state.copyWith(
              status: SessionCubitStatus.active,
              session: session,
              currentAyahIndex:
                  _sessionEngine.nextActionableAyahIndex(session) ?? 0,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: SessionCubitStatus.error,
              errorMessage: 'No active session found',
            ),
          );
        }
      },
    );
  }

  Future<bool> completeLearnStep(int ayahNumber) async {
    if (state.session == null) return false;
    try {
      final updated = _sessionEngine.completeLearnStep(
        state.session!,
        ayahNumber,
      );
      return _persistUpdatedSession(updated);
    } catch (e) {
      emit(
        state.copyWith(
          status: SessionCubitStatus.error,
          errorMessage: e.toString(),
        ),
      );
      return false;
    }
  }

  Future<bool> completeMemorizeStep(int ayahNumber, int hintLevel) async {
    if (state.session == null) return false;
    try {
      final updated = _sessionEngine.completeMemorizeStep(
        state.session!,
        ayahNumber,
        hintLevel,
      );
      return _persistUpdatedSession(updated);
    } catch (e) {
      emit(
        state.copyWith(
          status: SessionCubitStatus.error,
          errorMessage: e.toString(),
        ),
      );
      return false;
    }
  }

  Future<bool> evaluateRecitation(int ayahNumber, double score) async {
    if (state.session == null) return false;
    final result = await _evaluateRecitation(
      session: state.session!,
      ayahNumber: ayahNumber,
      similarityScore: score,
    );
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: SessionCubitStatus.error,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (updated) {
        emit(state.copyWith(session: updated));
        return true;
      },
    );
  }

  /// Moves to the next ayah or lifecycle stage after the current input is saved.
  Future<void> advanceAfterCurrentAyah() async {
    final session = state.session;
    if (session == null) return;

    final nextIndex = _sessionEngine.nextActionableAyahIndex(
      session,
      afterIndex: state.currentAyahIndex,
    );
    if (nextIndex != null) {
      emit(state.copyWith(currentAyahIndex: nextIndex));
      return;
    }

    if (session.stage == SessionStage.blockReview &&
        !session.ayahProgress.any((ayah) => ayah.isFailed)) {
      await _completeSession(session);
      return;
    }

    await _advanceStage(session);
  }

  Future<void> _advanceStage(SessionEntity session) async {
    emit(state.copyWith(status: SessionCubitStatus.loading));
    final result = await _advanceSession(session);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: SessionCubitStatus.error,
          errorMessage: l.message,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: SessionCubitStatus.active,
          session: updated,
          currentAyahIndex:
              _sessionEngine.nextActionableAyahIndex(updated) ?? 0,
        ),
      ),
    );
  }

  Future<void> _completeSession(SessionEntity session) async {
    emit(state.copyWith(status: SessionCubitStatus.completing));
    final result = await _completeSessionUseCase(session);
    result.fold(
      (l) => emit(
        state.copyWith(
          status: SessionCubitStatus.error,
          errorMessage: l.message,
        ),
      ),
      (updated) => emit(
        state.copyWith(status: SessionCubitStatus.completed, session: updated),
      ),
    );
  }

  void nextAyah() {
    if (state.session == null) return;
    if (state.currentAyahIndex < state.session!.ayahProgress.length - 1) {
      emit(state.copyWith(currentAyahIndex: state.currentAyahIndex + 1));
    }
  }

  void previousAyah() {
    if (state.currentAyahIndex > 0) {
      emit(state.copyWith(currentAyahIndex: state.currentAyahIndex - 1));
    }
  }

  void setInitialAyahForStage() {
    final session = state.session;
    if (session == null) return;
    final index = _sessionEngine.nextActionableAyahIndex(session);
    if (index != null) emit(state.copyWith(currentAyahIndex: index));
  }

  Future<bool> _persistUpdatedSession(SessionEntity updated) async {
    final result = await _sessionRepository.saveSession(updated);
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: SessionCubitStatus.error,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (_) {
        emit(state.copyWith(session: updated));
        return true;
      },
    );
  }
}

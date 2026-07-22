import 'package:equatable/equatable.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';

enum SessionCubitStatus { initial, loading, active, completing, completed, error }

class SessionState extends Equatable {
  final SessionCubitStatus status;
  final SessionEntity? session;
  final int currentAyahIndex;
  final String? errorMessage;

  const SessionState({
    this.status = SessionCubitStatus.initial,
    this.session,
    this.currentAyahIndex = 0,
    this.errorMessage,
  });

  SessionState copyWith({
    SessionCubitStatus? status,
    SessionEntity? session,
    int? currentAyahIndex,
    String? errorMessage,
  }) {
    return SessionState(
      status: status ?? this.status,
      session: session ?? this.session,
      currentAyahIndex: currentAyahIndex ?? this.currentAyahIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, session, currentAyahIndex, errorMessage];
}

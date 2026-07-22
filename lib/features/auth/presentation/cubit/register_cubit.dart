import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talia/features/auth/domain/usecases/register_use_case.dart';
import 'package:talia/features/auth/presentation/cubit/register_state.dart';
import 'package:talia/features/auth/domain/entities/user_entity.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  UserEntity? lastRegisteredUser;

  RegisterCubit({
    required this._registerUseCase,
  })  : super(const RegisterInitial());

  Future<void> register({
    required String email, 
    required String password,
    String? displayName,
  }) async {
    emit(const RegisterLoading());
    final result = await _registerUseCase(email: email, password: password, displayName: displayName);
    result.fold(
      (failure) => emit(RegisterFailure(failure.message)),
      (user) {
        lastRegisteredUser = user;
        emit(const RegisterSuccess());
      },
    );
  }
}

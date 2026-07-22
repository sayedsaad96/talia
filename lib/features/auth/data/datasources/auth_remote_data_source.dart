import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talia/core/error/exceptions.dart' as app;
import 'package:talia/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(String email, String password, String? displayName);
  Future<void> signOut();
  UserModel? getCurrentUser();
  Stream<UserModel?> onAuthStateChange();
  Future<void> sendPasswordReset(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  const AuthRemoteDataSourceImpl(this._client);

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const app.AuthException(message: 'Login failed: No user returned');
      }
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw app.AuthException(message: e.message);
    } catch (e) {
      if (e is app.AuthException) rethrow;
      throw app.ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmail(String email, String password, String? displayName) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );
      if (response.user == null) {
        throw const app.AuthException(message: 'Registration failed: No user returned');
      }
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw app.AuthException(message: e.message);
    } catch (e) {
      if (e is app.AuthException) rethrow;
      throw app.ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw app.ServerException(message: e.toString());
    }
  }

  @override
  UserModel? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return UserModel.fromSupabaseUser(user);
  }

  @override
  Stream<UserModel?> onAuthStateChange() {
    return _client.auth.onAuthStateChange.map((authState) {
      final user = authState.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    });
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw app.AuthException(message: e.message);
    } catch (e) {
      if (e is app.AuthException) rethrow;
      throw app.ServerException(message: e.toString());
    }
  }
}

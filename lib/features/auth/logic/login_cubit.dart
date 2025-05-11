import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/services/token_storage_service.dart';
import 'package:grade3/features/auth/data/service/auth_service.dart';
import 'package:grade3/features/auth/logic/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final response =
          await AuthService.login(email: email, password: password);

      final token = response.token;
      if (token != null && token.isNotEmpty) {
        Map<String, dynamic> payload = Jwt.parseJwt(token);
        final userId = payload['_id']?.toString();

        if (userId != null && userId.isNotEmpty) {
          await TokenStorageService.saveToken(token.toString(), userId);
          prefs.setString('reciveId', userId);
          log('Login successful. Token: $token');
          log('Extracted userId from token: $userId');
          emit(LoginSuccess(response));
        } else {
          log('Login failed: User ID is null');
          emit(LoginError('Login failed: User ID is null'));
        }
      } else {
        log('Login failed: Token is null');
        emit(LoginError('Login failed: Token is null'));
      }
    } catch (e) {
      log('Login error: $e');
      emit(LoginError('Login error: $e'));
    }
  }

  Future<void> logout() async {
    try {
      await TokenStorageService.clearToken();
      emit(LoginInitial());
    } catch (e) {
      log('Error during logout: $e');
      emit(LoginError('Error during logout: $e'));
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      final isLoggedIn = await TokenStorageService.isLoggedIn();
      if (isLoggedIn) {
        emit(LoginAlreadyLoggedIn());
      } else {
        emit(LoginInitial());
      }
    } catch (e) {
      log('Error checking login status: $e');
      emit(LoginError('Error checking login status: $e'));
    }
  }
}

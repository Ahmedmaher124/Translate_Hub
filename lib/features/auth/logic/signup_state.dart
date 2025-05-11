import 'package:grade3/features/auth/data/model/signup_response_model.dart';

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final SignupResponseModel signupResponse;

  SignupSuccess(this.signupResponse);
}

class SignupError extends SignupState {
  final String error;

  SignupError(this.error);
}

class SignupRetrying extends SignupState {
  final int currentAttempt;
  final int maxAttempts;
  final String errorMessage;

  SignupRetrying({
    required this.currentAttempt,
    required this.maxAttempts,
    required this.errorMessage,
  });
}

// Translator creation states
class TranslatorCreationLoading extends SignupState {}

class TranslatorCreationSuccess extends SignupState {
  final dynamic response;

  TranslatorCreationSuccess(this.response);
}

class TranslatorCreationError extends SignupState {
  final String error;

  TranslatorCreationError(this.error);
}

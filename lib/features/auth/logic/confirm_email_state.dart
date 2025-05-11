// lib/cubit/confirm_email_state.dart
part of 'confirm_email_cubit.dart';

abstract class ConfirmEmailState {}

class ConfirmEmailInitial extends ConfirmEmailState {}

class ConfirmEmailLoading extends ConfirmEmailState {}

class ConfirmEmailSuccess extends ConfirmEmailState {
  final String message;

  ConfirmEmailSuccess(this.message);
}

class ConfirmEmailFailure extends ConfirmEmailState {
  final String error;

  ConfirmEmailFailure(this.error);
}

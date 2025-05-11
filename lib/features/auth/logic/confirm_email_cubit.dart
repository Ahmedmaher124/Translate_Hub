// lib/cubit/confirm_email_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/features/auth/data/service/auth_service.dart';

part 'confirm_email_state.dart';

class ConfirmEmailCubit extends Cubit<ConfirmEmailState> {
  final AuthService confirmEmailService;

  ConfirmEmailCubit({required this.confirmEmailService})
      : super(ConfirmEmailInitial());

  // دالة لتأكيد الإيميل
  Future<void> confirmEmail(String email, String code) async {
    try {
      emit(ConfirmEmailLoading()); // في حالة التحميل
      await confirmEmailService.confirmEmail(email: email, code: code);
      emit(ConfirmEmailSuccess('Email confirmed successfully!'));
    } catch (e) {
      emit(ConfirmEmailFailure('Error: ${e.toString()}'));
    }
  }
}

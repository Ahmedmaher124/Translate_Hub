import 'package:grade3/features/user_account/data/models/user_profile_model.dart';

class UpdateProfileResponse {
  final String message;
  final UserProfileModel user;
  final bool success;

  UpdateProfileResponse({
    required this.message,
    required this.user,
    required this.success,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      message: json['message'] ?? '',
      user: UserProfileModel.fromJson(json['user'] ?? {}),
      success: json['success'] ?? true,
    );
  }
}

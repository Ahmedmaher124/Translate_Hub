import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/services/token_storage_service.dart';
import 'package:grade3/features/user_account/data/models/update_profile_request.dart';
import 'package:grade3/features/user_account/data/models/user_profile_model.dart';
import 'package:grade3/features/user_account/data/services/user_profile_service.dart';
import 'package:grade3/features/user_account/logic/user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserProfileService _userProfileService = UserProfileService();

  UserProfileCubit() : super(UserProfileInitial());

  Future<void> getUserProfile() async {
    emit(UserProfileLoading());
    try {
      // Get token using TokenStorageService
      final token = await TokenStorageService.getToken();

      if (token == null) {
        emit(const UserProfileError('User not authenticated'));
        return;
      }

      final UserProfileModel userProfile =
          await _userProfileService.getUserProfile(token: token);
      emit(UserProfileLoaded(userProfile));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  Future<bool> updateUserProfile({
    required String name,
    required String mobileNumber,
    required String gender,
    required String dob,
    String? bio,
    String? location,
    int? experienceYears,
    List<String>? languages,
    List<String>? types,
  }) async {
    emit(UserProfileLoading());
    try {
      // Get token using TokenStorageService
      final token = await TokenStorageService.getToken();

      if (token == null) {
        emit(const UserProfileError('User not authenticated'));
        return false;
      }

      final request = UpdateProfileRequest(
        name: name,
        mobileNumber: mobileNumber,
        gender: gender,
        dob: dob,
        bio: bio ?? '',
        location: location ?? '',
        experienceYears: experienceYears ?? 0,
        languages: languages ?? [],
        types: types ?? [],
      );

      final response = await _userProfileService.updateUserProfile(
        token: token,
        request: request,
      );

      emit(UserProfileLoaded(response.user));
      return response.success;
    } catch (e) {
      emit(UserProfileError(e.toString()));
      return false;
    }
  }
}

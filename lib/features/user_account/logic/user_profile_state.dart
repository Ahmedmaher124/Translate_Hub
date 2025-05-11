import 'package:grade3/features/user_account/data/models/user_profile_model.dart';

abstract class UserProfileState {
  const UserProfileState();
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfileModel userProfile;

  const UserProfileLoaded(this.userProfile);
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);
}

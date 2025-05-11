import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/features/home/presentation/views/widgets/custom_rounded_image.dart';
import 'package:grade3/features/home/presentation/views/widgets/welcome_widget.dart';
import 'package:grade3/features/user_account/logic/user_profile_cubit.dart';
import 'package:grade3/features/user_account/logic/user_profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();

    if (context.read<UserProfileCubit>().state is! UserProfileLoaded) {
      context.read<UserProfileCubit>().getUserProfile();
    }
  }

  Future<void> _loadProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('profile_image_path');
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          setState(() {
            _profileImage = file;
          });
        }
      }
    } catch (e) {
      log('Error loading profile image in AppBar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                String userName = "User";
                if (state is UserProfileLoaded) {
                  userName = state.userProfile.name.split(' ').first;
                }
                return WelcomWidget(userName: userName);
              },
            ),
            BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                String? profileImageUrl;
                if (state is UserProfileLoaded) {
                  profileImageUrl = state.userProfile.profileImageUrl;
                }

                final bool hasRemoteImage =
                    profileImageUrl != null && profileImageUrl.isNotEmpty;

                return CustomRoundedImage(
                  imageFile: !hasRemoteImage ? _profileImage : null,
                  imageUrl: hasRemoteImage ? profileImageUrl : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

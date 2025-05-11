import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grade3/core/utils/app_router.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';
import 'package:grade3/features/auth/logic/login_cubit.dart';
import 'package:grade3/features/auth/logic/login_state.dart';
import 'package:grade3/features/home/presentation/views/widgets/custom_rounded_image.dart';
import 'package:grade3/features/user_account/data/models/user_profile_model.dart';
import 'package:grade3/features/user_account/logic/user_profile_cubit.dart';
import 'package:grade3/features/user_account/logic/user_profile_state.dart';
import 'package:grade3/features/user_account/presentation/views/edit_profile_view.dart';

class UserAccountView extends StatefulWidget {
  const UserAccountView({super.key});

  @override
  State<UserAccountView> createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  @override
  void initState() {
    super.initState();
    // Only call getUserProfile if not already loaded
    final userProfileState = context.read<UserProfileCubit>().state;
    if (userProfileState is! UserProfileLoaded) {
      context.read<UserProfileCubit>().getUserProfile();
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await context.read<LoginCubit>().logout();
      if (context.mounted) {
        GoRouter.of(context).go(AppRouter.loginView);
      }
    }
  }

  void _navigateToEditProfile(
      BuildContext context, UserProfileModel userProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileView(userProfile: userProfile),
      ),
    ).then((updated) {
      if (updated == true) {
        // Refresh user profile data if profile was updated
        context.read<UserProfileCubit>().getUserProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginInitial) {
              GoRouter.of(context).go(AppRouter.loginView);
            }
          },
        ),
        BlocListener<UserProfileCubit, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserProfileLoaded) {
                return _buildProfileContent(context, state.userProfile);
              } else if (state is UserProfileError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context, UserProfileModel userProfile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          _buildCoverAndProfileSection(context, userProfile),
          _buildUserInfoCard(context, userProfile),
          _buildActionButtons(context, userProfile),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Profile',
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, baseFontSize: 24),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverAndProfileSection(
      BuildContext context, UserProfileModel userProfile) {
    final bool hasProfileImage = userProfile.profileImageUrl != null &&
        userProfile.profileImageUrl!.isNotEmpty;
    final bool hasCoverImage = userProfile.coverImageUrl != null &&
        userProfile.coverImageUrl!.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Cover Image
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            image: hasCoverImage
                ? DecorationImage(
                    image: NetworkImage(userProfile.coverImageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),

        // Profile Image
        Positioned(
          bottom: -50,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: CustomRoundedImage(
              imageUrl: hasProfileImage ? userProfile.profileImageUrl : null,
              width: 100,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(
      BuildContext context, UserProfileModel userProfile) {
    return Container(
      margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  userProfile.name,
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(context, baseFontSize: 22),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userProfile.email,
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(context, baseFontSize: 14),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            title: 'Mobile Number',
            value: userProfile.mobileNumber.isNotEmpty
                ? userProfile.mobileNumber
                : 'Not specified',
          ),
          _buildInfoRow(
            icon: Icons.person_outline,
            title: 'Gender',
            value: userProfile.gender.isNotEmpty
                ? userProfile.gender.substring(0, 1).toUpperCase() +
                    userProfile.gender.substring(1)
                : 'Not specified',
          ),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            title: 'Date of Birth',
            value: _formatDate(userProfile.dob),
          ),
          _buildInfoRow(
            icon: Icons.cake_outlined,
            title: 'Age',
            value: userProfile.age > 0
                ? userProfile.age.toString()
                : 'Not specified',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, UserProfileModel userProfile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _navigateToEditProfile(context, userProfile),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handleLogout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'Not specified';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

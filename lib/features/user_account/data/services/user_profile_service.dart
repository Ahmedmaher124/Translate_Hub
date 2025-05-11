import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:grade3/features/user_account/data/models/update_profile_request.dart';
import 'package:grade3/features/user_account/data/models/update_profile_response.dart';
import 'package:grade3/features/user_account/data/models/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://translator-project-seven.vercel.app';

  Future<UserProfileModel> getUserProfile({required String token}) async {
    try {
      log('Fetching user profile with token: ${token.substring(0, 20)}...');
      final prefs = await SharedPreferences.getInstance();
      final response = await _dio.get(
        '$_baseUrl/user/get-login-user',
        options: Options(
          headers: {
            'token': token,
          },
          validateStatus: (status) =>
              true, // Accept all status codes for better error handling
        ),
      );

      prefs.setString('reciveId', response.data['user']['_id']);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['user'] != null) {
          log('User data found, parsing...');
          return UserProfileModel.fromJson(data['user']);
        } else {
          log('User data not found in response');
          throw Exception('User data not found in the response');
        }
      } else if (response.statusCode == 401) {
        log('Unauthorized: Invalid or expired token');
        throw Exception('Unauthorized: Please login again');
      } else {
        log('API error: ${response.statusCode} - ${response.statusMessage}');
        throw Exception(
            'Failed to fetch user profile: ${response.statusMessage} (${response.statusCode})');
      }
    } catch (e) {
      log('Error fetching user profile: $e');
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<UpdateProfileResponse> updateUserProfile({
    required String token,
    required UpdateProfileRequest request,
  }) async {
    try {
      log('Updating user profile with token: ${token.substring(0, 20)}...');
      log('Request data: ${request.toJson()}');

      final response = await _dio.put(
        '$_baseUrl/user/update',
        data: request.toJson(),
        options: Options(
          headers: {
            'token': token,
          },
          validateStatus: (status) => true,
        ),
      );

      log('Update profile response status: ${response.statusCode}');
      if (response.data != null) {
        log('Response data: ${response.data}');
      }

      if (response.statusCode == 200) {
        final updateResponse = UpdateProfileResponse.fromJson(response.data);
        log('User profile updated successfully');
        return updateResponse;
      } else if (response.statusCode == 401) {
        // Check if it's a validation error
        if (response.data != null &&
            response.data['errors'] != null &&
            response.data['errors'] is List &&
            response.data['errors'].isNotEmpty) {
          final List<dynamic> errors = response.data['errors'];
          final List<String> errorMessages = errors
              .map(
                  (error) => error['message']?.toString() ?? 'Validation error')
              .toList();

          final String errorMessage =
              'Validation errors: ${errorMessages.join(', ')}';
          log(errorMessage);
          throw Exception(errorMessage);
        } else {
          log('Unauthorized: Invalid or expired token');
          throw Exception('Unauthorized: Please login again');
        }
      } else {
        log('API error: ${response.statusCode} - ${response.statusMessage}');
        throw Exception(
            'Failed to update user profile: ${response.statusMessage} (${response.statusCode})');
      }
    } catch (e) {
      log('Error updating user profile: $e');
      throw Exception('Failed to update user profile: $e');
    }
  }
}

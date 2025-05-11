import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:grade3/features/auth/data/model/login_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:grade3/features/auth/data/model/signup_response_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Signup method using http
  Future<SignupResponseModel> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String mobileNumber,
    required String gender,
    required String dob,
    File? profilePic,
    File? coverPic,
  }) async {
    final Uri url =
        Uri.parse('https://translator-project-seven.vercel.app/auth/signup');

    // If profile image or cover image is provided, use multipart request
    if (profilePic != null || coverPic != null) {
      try {
        var request = http.MultipartRequest('POST', url);

        // Add text fields
        request.fields['name'] = name;
        request.fields['email'] = email;
        request.fields['password'] = password;
        request.fields['confirmPassword'] = confirmPassword;
        request.fields['mobileNumber'] = mobileNumber;
        request.fields['gender'] = gender;
        request.fields['DOB'] = dob;

        // Add profile image with proper content type if available
        if (profilePic != null) {
          String fileExtension = profilePic.path.split('.').last.toLowerCase();
          String contentType = 'image/jpeg'; // Default to jpeg

          if (fileExtension == 'png') {
            contentType = 'image/png';
          } else if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
            contentType = 'image/jpeg';
          }

          request.files.add(
            await http.MultipartFile.fromPath(
              'profilePic',
              profilePic.path,
              contentType: MediaType.parse(contentType),
            ),
          );
        }

        // Add cover image with proper content type if available
        if (coverPic != null) {
          String fileExtension = coverPic.path.split('.').last.toLowerCase();
          String contentType = 'image/jpeg'; // Default to jpeg

          if (fileExtension == 'png') {
            contentType = 'image/png';
          } else if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
            contentType = 'image/jpeg';
          }

          request.files.add(
            await http.MultipartFile.fromPath(
              'coverPic',
              coverPic.path,
              contentType: MediaType.parse(contentType),
            ),
          );
        }

        // Send the request
        final streamedResponse =
            await request.send().timeout(const Duration(seconds: 30));
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 201) {
          return SignupResponseModel.fromJson(
              json.decode(response.body), email);
        } else {
          // Try without the images if we get a server error
          return await _signupWithoutImage(name, email, password,
              confirmPassword, mobileNumber, gender, dob);
        }
      } catch (e) {
        // Fall back to signup without image
        return await _signupWithoutImage(
            name, email, password, confirmPassword, mobileNumber, gender, dob);
      }
    } else {
      return await _signupWithoutImage(
          name, email, password, confirmPassword, mobileNumber, gender, dob);
    }
  }

  // Helper method for signup without image
  Future<SignupResponseModel> _signupWithoutImage(
    String name,
    String email,
    String password,
    String confirmPassword,
    String mobileNumber,
    String gender,
    String dob,
  ) async {
    final Uri url =
        Uri.parse('https://translator-project-seven.vercel.app/auth/signup');

    final response = await http.post(
      url,
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'mobileNumber': mobileNumber,
        'gender': gender,
        'DOB': dob,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return SignupResponseModel.fromJson(json.decode(response.body), email);
    } else {
      throw Exception('Failed to signup: ${response.reasonPhrase}');
    }
  }

  // Create translator profile
  Future<dynamic> createTranslator({
    required String email,
    required File? certifications,
    required String languages,
    required String experienceYears,
    required String bio,
    required String types,
    required File? cv,
    required String location,
  }) async {
    final Uri url = Uri.parse(
        'https://translator-project-seven.vercel.app/translator/create/$email');

    // Create multipart request
    var request = http.MultipartRequest('POST', url);

    // Ensure type is lowercase and valid
    String validType = types.toLowerCase();
    if (!["editorial", "immediate", "emergency"].contains(validType)) {
      validType = "editorial"; // Default to editorial if invalid
    }

    // Add text fields
    request.fields['languages'] = languages;
    request.fields['experienceYears'] = experienceYears;
    request.fields['bio'] = bio;
    request.fields['type'] = validType;
    request.fields['location'] = location;

    // Add headers for authentication
    request.headers['Content-Type'] = 'multipart/form-data';

    // Get stored token if available
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Add file fields
    if (certifications != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'certifications',
        certifications.path,
        contentType: MediaType('application', 'pdf'),
      ));
    }

    if (cv != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'cv',
        cv.path,
        contentType: MediaType('application', 'pdf'),
      ));
    }

    // Send the request
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to create translator profile: ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create translator profile: $e');
    }
  }

  // Login method using http
  static Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final url =
        Uri.parse('https://translator-project-seven.vercel.app/auth/signin');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  // Confirm email method using http (PUT request)
  Future<void> confirmEmail({
    required String email,
    required String code,
  }) async {
    final Uri url = Uri.parse(
        'https://translator-project-seven.vercel.app/auth/confirm-email');

    final request = http.Request('PUT', url)
      ..headers.addAll({'Content-Type': 'application/json'})
      ..body = jsonEncode({'email': email, 'code': code});

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    log(responseData.toString());

    // if (response.statusCode == 200) {

    //   print('Email confirmed successfully: $responseData');
    // } else {
    //   print('Failed to confirm email: ${response.reasonPhrase}');
    //   throw Exception('Failed to confirm email: ${response.reasonPhrase}');
    // }
  }

  // Create translator profile with direct API call (for debugging)
  Future<dynamic> createTranslatorDirect({
    required String email,
    required String languages,
    required String experienceYears,
    required String bio,
    required String types,
    required String location,
  }) async {
    final Uri url = Uri.parse(
        'https://translator-project-seven.vercel.app/translator/create/$email');

    try {
      // Ensure type is lowercase and valid
      String validType = types.toLowerCase();
      if (!["editorial", "immediate", "emergency"].contains(validType)) {
        validType = "editorial"; // Default to editorial if invalid
      }

      // Make a direct JSON request instead of multipart
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'languages': languages,
          'experienceYears': experienceYears,
          'bio': bio,
          'type': validType,
          'location': location,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed: ${response.reasonPhrase} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create translator profile: $e');
    }
  }
}

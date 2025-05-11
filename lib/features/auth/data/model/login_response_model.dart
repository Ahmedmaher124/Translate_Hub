class LoginResponse {
  final String message;
  final String? token;

  LoginResponse({
    required this.message,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'] is String
          ? json['token']
          : json['token']?['accessToken'],
    );
  }
}

class SignupResponseModel {
  final String message;
  final String email;

  SignupResponseModel({
    required this.email,
    required this.message,
  });

  factory SignupResponseModel.fromJson(
      Map<String, dynamic> json, String email) {
    return SignupResponseModel(
      message: json['message'] as String,
      email: email,
    );
  }
}

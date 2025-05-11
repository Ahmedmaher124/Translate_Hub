class UpdateProfileRequest {
  final String name;
  final String mobileNumber;
  final String gender;
  final String dob;
  final List<String> languages;
  final List<String> types;
  final String bio;
  final int experienceYears;
  final String location;

  UpdateProfileRequest({
    required this.name,
    required this.mobileNumber,
    required this.gender,
    required this.dob,
    this.languages = const [],
    this.types = const [],
    this.bio = '',
    this.experienceYears = 0,
    String location = '',
  }) : this.location = location.isEmpty ? 'Not specified' : location;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'DOB': dob,
      'language': languages,
      'type': types,
      'bio': bio,
      'experienceYears': experienceYears,
      'location': location,
    };
  }
}

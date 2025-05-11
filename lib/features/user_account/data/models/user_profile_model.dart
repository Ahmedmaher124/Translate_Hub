class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String provider;
  final String gender;
  final String dob;
  final String mobileNumber;
  final String role;
  final bool isTranslator;
  final bool isVerified;
  final String mediaCloudFolder;
  final int age;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final String? bio;
  final String? location;
  final int? experienceYears;
  final List<String>? languages;
  final List<String>? types;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.provider,
    required this.gender,
    required this.dob,
    required this.mobileNumber,
    required this.role,
    required this.isTranslator,
    required this.isVerified,
    required this.mediaCloudFolder,
    required this.age,
    this.profileImageUrl,
    this.coverImageUrl,
    this.bio,
    this.location,
    this.experienceYears,
    this.languages,
    this.types,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle profile image - check both new and old formats
    String? profileImageUrl;
    if (json['profilePic'] != null && json['profilePic'] is Map) {
      profileImageUrl = json['profilePic']['secure_url'];
    } else {
      profileImageUrl = json['profileImageUrl'] ?? json['profileImage'] ?? '';
    }

    // Handle cover image - check for new format
    String? coverImageUrl;
    if (json['coverPic'] != null && json['coverPic'] is Map) {
      coverImageUrl = json['coverPic']['secure_url'];
    } else {
      coverImageUrl = json['coverImageUrl'] ?? '';
    }

    return UserProfileModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      provider: json['provider'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['DOB'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      role: json['role'] ?? '',
      isTranslator: json['isTranslator'] ?? false,
      isVerified: json['isVerified'] ?? false,
      mediaCloudFolder: json['mediaCloudFolder'] ?? '',
      age: json['age'] ?? 0,
      profileImageUrl: profileImageUrl,
      coverImageUrl: coverImageUrl,
      bio: json['bio'],
      location: json['location'],
      experienceYears: json['experienceYears'],
      languages:
          json['language'] != null ? List<String>.from(json['language']) : null,
      types: json['type'] != null ? List<String>.from(json['type']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'provider': provider,
      'gender': gender,
      'DOB': dob,
      'mobileNumber': mobileNumber,
      'role': role,
      'isTranslator': isTranslator,
      'isVerified': isVerified,
      'mediaCloudFolder': mediaCloudFolder,
      'age': age,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      if (bio != null) 'bio': bio,
      if (location != null) 'location': location,
      if (experienceYears != null) 'experienceYears': experienceYears,
      if (languages != null) 'language': languages,
      if (types != null) 'type': types,
    };
  }
}

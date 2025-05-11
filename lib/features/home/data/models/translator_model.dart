// class TranslatorModel {
//   final String name;
//   final String userId;
//   final String image;
//   final int experianceYears;
//   final double avgRating;
//   final String location;
//   final String bio;
//   final List language;
//   final List type;

//   TranslatorModel({
//     required this.name,
//     required this.userId,
//     required this.image,
//     required this.experianceYears,
//     required this.avgRating,
//     required this.location,
//     required this.bio,
//     required this.language,
//     required this.type,
//   });

//   factory TranslatorModel.fromJson(jsonData) {
//     String image = '';
//     if (jsonData['profilePic'] != null &&
//         jsonData['profilePic']['secure_url'] != null) {
//       image = jsonData['profilePic']['secure_url'];
//     }

//     return TranslatorModel(
//       name: jsonData['name'],
//       userId: jsonData['_id'],
//       image: image,
//       experianceYears: jsonData['Translator'][0]['experienceYears'],
//       avgRating: jsonData['Translator'][0]['averageRating'].toDouble(),
//       location: jsonData['Translator'][0]['location'],
//       bio: jsonData['Translator'][0]['bio'],
//       language: jsonData['Translator'][0]['language'],
//       type: jsonData['Translator'][0]['type'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       '_id': userId,
//       'profilePic': {'secure_url': image},
//       'Translator': [
//         {
//           'experienceYears': experianceYears,
//           'averageRating': avgRating,
//           'location': location,
//           'bio': bio,
//           'language': language,
//           'type': type,
//         }
//       ]
//     };
//   }
// }

class TranslatorModel {
  final String name;
  final String userId;
  final String image;
  final int experianceYears;
  final double avgRating;
  final String location;
  final String bio;
  final List language;
  final List type;

  TranslatorModel({
    required this.name,
    required this.userId,
    required this.image,
    required this.experianceYears,
    required this.avgRating,
    required this.location,
    required this.bio,
    required this.language,
    required this.type,
  });

  factory TranslatorModel.fromJson(jsonData) {
    String image = '';
    if (jsonData['profilePic'] != null &&
        jsonData['profilePic']['secure_url'] != null) {
      image = jsonData['profilePic']['secure_url'];
    }

    return TranslatorModel(
      name: jsonData['name'],
      userId: jsonData['_id'],
      image: image,
      experianceYears: jsonData['Translator'][0]['experienceYears'],
      avgRating: jsonData['Translator'][0]['averageRating'].toDouble(),
      location: jsonData['Translator'][0]['location'],
      bio: jsonData['Translator'][0]['bio'],
      language: jsonData['Translator'][0]['language'],
      type: jsonData['Translator'][0]['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      '_id': userId,
      'profilePic': {'secure_url': image},
      'Translator': [
        {
          'experienceYears': experianceYears,
          'averageRating': avgRating,
          'location': location,
          'bio': bio,
          'language': language,
          'type': type,
        }
      ]
    };
  }
}

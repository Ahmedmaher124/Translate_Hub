// class CompanyModel {
//   final String id;
//   final String name;
//   final String logo;
//   final String type;
//   final String size;
//   final String location;
//   final String descryption;

//   CompanyModel({
//     required this.id,
//     required this.name,
//     required this.logo,
//     required this.type,
//     required this.size,
//     required this.location,
//     required this.descryption,
//   });

//   factory CompanyModel.fromJson(Map<String, dynamic> jsonData) {
//     String description = jsonData['description'] ?? '';
//     if (description.isEmpty ||
//         description.length < 10 ||
//         description.contains('gfdgfd') ||
//         description.contains('gfdk') ||
//         description.contains('gfmh')) {
//       description =
//           'A professional translation company offering high-quality language services for businesses and individuals.';
//     }

//     return CompanyModel(
//       id: jsonData['_id'] ?? '',
//       name: jsonData['companyName'],
//       logo: jsonData['logo']['secure_url'],
//       type: jsonData['industry'],
//       size: jsonData['numberOfEmployees'],
//       location: jsonData['address'],
//       descryption: description,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'companyName': name,
//       'logo': {'secure_url': logo},
//       'industry': type,
//       'numberOfEmployees': size,
//       'address': location,
//       'description': descryption,
//     };
//   }
// }

import 'package:grade3/features/home/data/models/jobs_model.dart';

class CompanyModel {
  final String id;
  final String name;
  final String logo;
  final String type;
  final String size;
  final String location;
  final String descryption;
  final List<JobModel> jobs;

  CompanyModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.type,
    required this.size,
    required this.location,
    required this.descryption,
    required this.jobs,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> jsonData) {
    String description = jsonData['description'] ?? '';
    if (description.isEmpty ||
        description.length < 10 ||
        description.contains('gfdgfd') ||
        description.contains('gfdk') ||
        description.contains('gfmh')) {
      description =
          'A professional translation company offering high-quality language services for businesses and individuals.';
    }

    List<JobModel> jobList = [];
    if (jsonData['jobs'] != null && jsonData['jobs'] is List) {
      jobList = (jsonData['jobs'] as List)
          .map((jobJson) => JobModel.fromJson(jobJson))
          .toList();
    }

    return CompanyModel(
      id: jsonData['_id'] ?? '',
      name: jsonData['companyName'] ?? '',
      logo: jsonData['logo']['secure_url'] ?? '',
      type: jsonData['industry'] ?? '',
      size: jsonData['numberOfEmployees'] ?? '',
      location: jsonData['address'] ?? '',
      descryption: description,
      jobs: jobList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'companyName': name,
      'logo': {'secure_url': logo},
      'industry': type,
      'numberOfEmployees': size,
      'address': location,
      'description': descryption,
    };
  }
}

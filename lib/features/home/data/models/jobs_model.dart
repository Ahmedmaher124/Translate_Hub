class JobModel {
  final String id;
  final String title;
  final String description;
  final String companyName;
  final String address;
  final List<String> requiredLanguages;
  final String jobType;
  final int budget;
  final String paymentMethod;
  final List<String> skillsRequired;
  final String status;
  final String jobLocation;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.companyName,
    required this.address,
    required this.requiredLanguages,
    required this.jobType,
    required this.budget,
    required this.paymentMethod,
    required this.skillsRequired,
    required this.status,
    required this.jobLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    final company = json['companyId'] ?? {};

    return JobModel(
      id: json['_id'] ?? 'N/A',
      title: json['title'] ?? 'Not found',
      description: json['description'] ?? 'Not found',
      companyName: company['companyName'] ?? 'Not found',
      address: company['address'] ?? 'Not found',
      requiredLanguages: List<String>.from(json['requiredLanguages'] ?? []),
      jobType: json['jobType'] ?? 'Not found',
      budget: json['budget'] ?? 0,
      paymentMethod: json['paymentMethod'] ?? 'Not found',
      skillsRequired: List<String>.from(json['skillsRequired'] ?? []),
      status: json['status'] ?? 'Unknown',
      jobLocation: json['jobLocation'] ?? 'Not found',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:grade3/features/home/data/models/company_model.dart';
import 'package:grade3/features/home/presentation/views/widgets/question_answar_column.dart';

class CompanyInfoCard extends StatelessWidget {
  const CompanyInfoCard({super.key, required this.companyModel});
  final CompanyModel companyModel;

  String _formatLocation(String location) {
    // Limit location length to prevent overflow
    if (location.length > 15) {
      return '${location.substring(0, 12)}...';
    }
    return location;
  }

  String _formatEmail(String email) {
    // Limit email length to prevent overflow
    if (email.length > 20) {
      return '${email.substring(0, 17)}...';
    }
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuestionAnswarColumn(
          question: 'Location',
          answar: _formatLocation(companyModel.location),
        ),
        QuestionAnswarColumn(
          question: 'Email',
          answar: _formatEmail(companyModel.id),
        ),
        QuestionAnswarColumn(
          question: 'Size',
          answar: companyModel.size,
        ),
      ],
    );
  }
}

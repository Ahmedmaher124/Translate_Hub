import 'package:flutter/material.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';
import 'package:grade3/features/home/data/models/company_model.dart';
import 'package:grade3/features/home/presentation/views/widgets/custom_rounded_image.dart';

class CompanyLogoName extends StatelessWidget {
  const CompanyLogoName({super.key, required this.companyModel});
  final CompanyModel companyModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomRoundedImage(
          imageUrl: companyModel.logo,
          width: MediaQuery.sizeOf(context).width * 0.137,
          isCompanyLogo: true,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              companyModel.name,
              style: TextStyle(
                fontSize: getResponsiveFontSize(
                  context,
                  baseFontSize: 15,
                ),
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              companyModel.type,
              style: TextStyle(
                fontSize: getResponsiveFontSize(
                  context,
                  baseFontSize: 10.5,
                ),
                // ignore: deprecated_member_use
                color: Colors.black26.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

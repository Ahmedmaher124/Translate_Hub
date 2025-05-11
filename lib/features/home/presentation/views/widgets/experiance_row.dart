import 'package:flutter/material.dart';
import 'package:grade3/core/utils/app_colors.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';

class ExperianceRow extends StatelessWidget {
  const ExperianceRow({
    super.key,
    this.years = 5,
  });

  final int years;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.work_outline_rounded,
          color: AppColors.categoryContainerColor,
          size: getResponsiveFontSize(
            context,
            baseFontSize: 18,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$years years',
          style: TextStyle(
            fontSize: getResponsiveFontSize(
              context,
              baseFontSize: 13,
            ),
            // ignore: deprecated_member_use
            color: Colors.black26.withOpacity(0.8),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

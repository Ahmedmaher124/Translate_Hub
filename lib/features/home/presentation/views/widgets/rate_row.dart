import 'package:flutter/material.dart';
import 'package:grade3/core/utils/app_colors.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';

class RateRow extends StatelessWidget {
  const RateRow({
    super.key,
    this.rating = 4.8,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star_border_outlined,
          color: AppColors.categoryContainerColor,
          size: getResponsiveFontSize(
            context,
            baseFontSize: 22,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: getResponsiveFontSize(
              context,
              baseFontSize: 14,
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

import 'package:flutter/material.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';

import 'package:grade3/features/home/presentation/views/widgets/custom_rounded_image.dart';

class TranslatorLogoName extends StatelessWidget {
  const TranslatorLogoName({super.key, required this.translatorModel});
  final TranslatorModel translatorModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomRoundedImage(
          imageUrl: translatorModel.image,
          width: MediaQuery.sizeOf(context).width * 0.137,
          // image: companyLogo,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              translatorModel.name,
              style: TextStyle(
                fontSize: getResponsiveFontSize(
                  context,
                  baseFontSize: 15.5,
                ),
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: getResponsiveFontSize(
                    context,
                    baseFontSize: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  translatorModel.avgRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(
                      context,
                      baseFontSize: 14,
                    ),
                    // ignore: deprecated_member_use
                    color: Colors.black26.withOpacity(0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

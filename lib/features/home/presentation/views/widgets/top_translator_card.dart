import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grade3/core/utils/app_router.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';
import 'package:grade3/features/home/presentation/views/widgets/custom_rounded_image.dart';
import 'package:grade3/features/home/presentation/views/widgets/experiance_row.dart';
import 'package:grade3/features/home/presentation/views/widgets/rate_row.dart';

class TopTranslatorCard extends StatelessWidget {
  const TopTranslatorCard({
    super.key,
    required this.translatorModel,
  });

  final TranslatorModel translatorModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(
          AppRouter.profileView,
          extra: translatorModel,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffEBEBEB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomRoundedImage(
                  imageUrl: translatorModel.image,
                  width: MediaQuery.sizeOf(context).width * 0.18,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      translatorModel.name,
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(
                          context,
                          baseFontSize: 14,
                        ),
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Immediate',
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(
                          context,
                          baseFontSize: 13,
                        ),
                        // ignore: deprecated_member_use
                        color: Colors.black26.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RateRow(rating: translatorModel.avgRating),
                        const SizedBox(width: 14),
                        ExperianceRow(years: translatorModel.experianceYears),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

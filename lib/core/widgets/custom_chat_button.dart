import 'package:flutter/material.dart';
import 'package:grade3/core/utils/app_colors.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';

class CustomChatButton extends StatelessWidget {
  const CustomChatButton({super.key, this.onTap});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: AppColors.categoryContainerColor,
          borderRadius: BorderRadius.circular(80),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.chat,
              //   color: Colors.white,
              //   size: getResponsiveIconSize(
              //     baseIconSize: 23,
              //     context: context,
              //   ),
              // ),
              const SizedBox(width: 8),
              Text(
                'Avilable Jobs',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(
                    context,
                    baseFontSize: 19,
                  ),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

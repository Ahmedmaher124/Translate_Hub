import 'package:flutter/material.dart';
import 'package:grade3/core/utils/app_colors.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';

class CategoryContainerListViewItem extends StatelessWidget {
  const CategoryContainerListViewItem({
    super.key,
    required this.categoryName,
    required this.onTap,
    required this.isSelected,
  });

  final String categoryName;
  final void Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.categoryContainerColor
              : AppColors.customBackgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: getResponsiveFontSize(
                baseFontSize: 16,
                context,
              ),
              color: isSelected ? Colors.white : AppColors.customTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

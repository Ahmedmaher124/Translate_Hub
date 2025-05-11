import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:grade3/core/utils/app_colors.dart';
import 'package:grade3/core/utils/get_responsive_icon_size_method.dart';
import 'package:grade3/features/home/presentation/manager/select_language_cubit.dart';

class CustomSearchTextField extends StatelessWidget {
  const CustomSearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        context.read<SelectLanguageCubit>().updateSearchQuery(value);
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        filled: true,
        fillColor: AppColors.customBackgroundColor,
        hintText: 'Search',
        hintStyle: TextStyle(
          color: AppColors.customTextColor,
          fontSize: getResponsiveIconSize(
            baseIconSize: 15,
            context: context,
          ),
        ),
        prefixIcon: Icon(
          FontAwesomeIcons.magnifyingGlass,
          color: AppColors.customTextColor,
          size: getResponsiveIconSize(
            baseIconSize: 18,
            context: context,
          ),
        ),
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: AppColors.customBackgroundColor,
        width: 0,
      ),
    );
  }
}

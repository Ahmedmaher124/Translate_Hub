import 'package:flutter/material.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';

class CustomErrorMessage extends StatelessWidget {
  const CustomErrorMessage({super.key, required this.errMessage});
  final String errMessage;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        textAlign: TextAlign.center,
        errMessage,
        style: TextStyle(
          fontSize: getResponsiveFontSize(
            context,
            baseFontSize: 16,
          ),
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

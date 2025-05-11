import 'package:flutter/material.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';

class WelcomWidget extends StatelessWidget {
  final String userName;

  const WelcomWidget({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, $userName 👋',
          style: TextStyle(
            fontSize: getResponsiveFontSize(
              context,
              baseFontSize: 15,
            ),
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Let\'s get started',
          style: TextStyle(
            height: 1.2,
            fontSize: getResponsiveFontSize(
              context,
              baseFontSize: 16,
            ),
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.85),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

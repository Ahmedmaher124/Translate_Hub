import 'package:flutter/material.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';

class TranslatorRow extends StatelessWidget {
  const TranslatorRow({
    super.key,
    required this.text1,
    required this.text2,
  });
  final String text1;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: TextStyle(
              fontSize: getResponsiveFontSize(
                context,
                baseFontSize: 18,
              ),
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            text2,
            style: TextStyle(
              fontSize: getResponsiveFontSize(
                context,
                baseFontSize: 13,
              ),
              // ignore: deprecated_member_use
              color: Colors.black45.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

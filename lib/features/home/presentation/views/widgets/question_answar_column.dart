import 'package:flutter/material.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';

class QuestionAnswarColumn extends StatelessWidget {
  const QuestionAnswarColumn({
    super.key,
    required this.question,
    required this.answar,
    this.crossAxisAlignment,
    this.answarFontSize,
    this.questionFontSize,
  });
  final String question;
  final String answar;
  final double? answarFontSize;
  final double? questionFontSize;
  final CrossAxisAlignment? crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          answar,
          style: TextStyle(
            fontSize: getResponsiveFontSize(
              context,
              baseFontSize: answarFontSize ?? 11,
            ),
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          question,
          style: TextStyle(
            fontSize: getResponsiveFontSize(
              context,
              baseFontSize: questionFontSize ?? 10,
            ),
            color: const Color.fromARGB(255, 46, 46, 72),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

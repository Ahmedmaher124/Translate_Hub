// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CustomTextField extends StatelessWidget {
//   final String? hintText;
//   final String labelText;
//   final bool isPassword;
//   final TextEditingController? controller;
//   final int? maxLines;

//   const CustomTextField({
//     super.key,
//     this.hintText,
//     required this.labelText,
//     this.isPassword = false,
//     this.controller,
//     this.maxLines = 1,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           labelText,
//           style: GoogleFonts.poppins(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: controller, // هنا بنضيف الـ controller
//           obscureText: isPassword,
//           maxLines: isPassword ? 1 : maxLines,
//           decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.grey,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide.none,
//             ),
//             filled: true,
//             fillColor: Colors.white,
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter $labelText'; // validation في حالة عدم إدخال البيانات
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ضروري عشان InputFormatters
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String labelText;
  final bool isPassword;
  final bool isNumber; // ⬅️ أضف هذه
  final TextEditingController? controller;
  final int? maxLines;

  const CustomTextField({
    super.key,
    this.hintText,
    required this.labelText,
    this.isPassword = false,
    this.isNumber = false, // ⬅️ القيمة الافتراضية false
    this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: isNumber
              ? TextInputType.number
              : TextInputType.text, // ⬅️ نوع الكيبورد
          inputFormatters: isNumber
              ? [FilteringTextInputFormatter.digitsOnly] // ⬅️ يمنع الحروف
              : [],
          maxLines: isPassword ? 1 : maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $labelText';
            }
            return null;
          },
        ),
      ],
    );
  }
}

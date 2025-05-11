// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:translate_hub/core/utils/app_router.dart';

// import 'package:translate_hub/core/utils/get_responsive_font_size.dart';

// import 'package:translate_hub/core/widgets/custom_chat_button.dart';
// import 'package:translate_hub/features/chat/presentation/views/chat_translator_item.dart';
// import 'package:translate_hub/features/home/data/models/translator_model.dart';
// import 'package:translate_hub/features/home/presentation/views/widgets/custom_rounded_image.dart';
// import 'package:translate_hub/features/home/presentation/views/widgets/question_answar_column.dart';

// class TranslatorProfileView extends StatelessWidget {
//   const TranslatorProfileView({
//     super.key,
//     required this.translatorModel,
//   });
//   final TranslatorModel translatorModel;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF2F2F2),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 26),
//           child: Column(
//             children: [
//               const SizedBox(height: 22),
//               Text(
//                 'Profile',
//                 style: TextStyle(
//                   fontSize: getResponsiveFontSize(
//                     context,
//                     baseFontSize: 22,
//                   ),
//                   color: Colors.black.withOpacity(0.9),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               CustomRoundedImage(
//                 imageUrl: translatorModel.image,
//                 width: MediaQuery.sizeOf(context).width * 0.3,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 translatorModel.name,
//                 style: TextStyle(
//                   fontSize: getResponsiveFontSize(
//                     context,
//                     baseFontSize: 21,
//                   ),
//                   color: Colors.black.withOpacity(0.9),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 22),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   QuestionAnswarColumn(
//                     answarFontSize: 12,
//                     questionFontSize: 14,
//                     question: translatorModel.experianceYears.toString(),
//                     answar: 'Experiance',
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                   ),
//                   QuestionAnswarColumn(
//                     answarFontSize: 12,
//                     questionFontSize: 14,
//                     question: translatorModel.avgRating.toStringAsFixed(1),
//                     answar: 'Rating',
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                   ),
//                   QuestionAnswarColumn(
//                     answarFontSize: 12,
//                     questionFontSize: 14,
//                     question: translatorModel.location,
//                     answar: 'Location',
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Text(
//                     'Descryption',
//                     style: TextStyle(
//                       fontSize: getResponsiveFontSize(
//                         context,
//                         baseFontSize: 18,
//                       ),
//                       color: Colors.black.withOpacity(0.8),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 translatorModel.bio,
//                 maxLines: 8,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: getResponsiveFontSize(
//                     context,
//                     baseFontSize: 15,
//                   ),
//                   color: Colors.black.withOpacity(0.5),
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Text(
//                     'Langueges',
//                     style: TextStyle(
//                       fontSize: getResponsiveFontSize(
//                         context,
//                         baseFontSize: 18,
//                       ),
//                       color: Colors.black.withOpacity(0.8),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: translatorModel.language.length,
//                   itemBuilder: (context, index) {
//                     return Text(
//                       translatorModel.language[index],
//                       style: TextStyle(
//                         fontSize: getResponsiveFontSize(
//                           context,
//                           baseFontSize: 14.5,
//                         ),
//                         color: Colors.black.withOpacity(0.9),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         height: 50,
//         width: double.infinity,
//         margin: const EdgeInsets.only(
//           left: 20,
//           right: 20,
//           bottom: 20,
//         ),
//         child: CustomChatButton(
//           // onTap: () {
//           //   // GoRouter.of(context).push(AppRouter.chatView);
//           // },
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatTranslatorPage(
//                   translator: translatorModel, // بعت المترجم هن
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:grade3/core/utils/get_responsive_font_size.dart';

import 'package:grade3/core/widgets/custom_chat_button.dart';
import 'package:grade3/features/chat/presentation/views/chat_translator_item.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';
import 'package:grade3/features/home/presentation/views/widgets/custom_rounded_image.dart';
import 'package:grade3/features/home/presentation/views/widgets/question_answar_column.dart';

class TranslatorProfileView extends StatelessWidget {
  const TranslatorProfileView({
    super.key,
    required this.translatorModel,
  });
  final TranslatorModel translatorModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              const SizedBox(height: 22),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(
                    context,
                    baseFontSize: 22,
                  ),
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              CustomRoundedImage(
                imageUrl: translatorModel.image,
                width: MediaQuery.sizeOf(context).width * 0.3,
              ),
              const SizedBox(height: 16),
              Text(
                translatorModel.name,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(
                    context,
                    baseFontSize: 21,
                  ),
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuestionAnswarColumn(
                    answarFontSize: 12,
                    questionFontSize: 14,
                    question: translatorModel.experianceYears.toString(),
                    answar: 'Experiance',
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  QuestionAnswarColumn(
                    answarFontSize: 12,
                    questionFontSize: 14,
                    question: translatorModel.avgRating.toStringAsFixed(1),
                    answar: 'Rating',
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  QuestionAnswarColumn(
                    answarFontSize: 12,
                    questionFontSize: 14,
                    question: translatorModel.location,
                    answar: 'Location',
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Descryption',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(
                        context,
                        baseFontSize: 18,
                      ),
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                translatorModel.bio,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(
                    context,
                    baseFontSize: 15,
                  ),
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Langueges',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(
                        context,
                        baseFontSize: 18,
                      ),
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: translatorModel.language.length,
                  itemBuilder: (context, index) {
                    return Text(
                      translatorModel.language[index],
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(
                          context,
                          baseFontSize: 14.5,
                        ),
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: CustomChatButton(
          // onTap: () {
          //   // GoRouter.of(context).push(AppRouter.chatView);
          // },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatTranslatorPage(
                  translator: translatorModel, // بعت المترجم هن
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

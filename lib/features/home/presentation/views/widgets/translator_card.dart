// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:translate_hub/core/utils/app_router.dart';
// import 'package:translate_hub/features/home/data/models/translator_model.dart';
// import 'package:translate_hub/features/home/presentation/views/widgets/chat_icon.dart';
// import 'package:translate_hub/features/home/presentation/views/widgets/translator_info_card.dart';
// import 'package:translate_hub/features/home/presentation/views/widgets/translator_logo_name.dart';

// class TranslatorCard extends StatelessWidget {
//   const TranslatorCard({super.key, required this.translatorModel});
//   final TranslatorModel translatorModel;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         GoRouter.of(context)
//             .push(AppRouter.profileView, extra: translatorModel);
//       },
//       child: Container(
//         width: MediaQuery.sizeOf(context).width - 32,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xffEBEBEB),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TranslatorLogoName(
//                   translatorModel: translatorModel,
//                 ),
//                 const ChatIcon(),
//               ],
//             ),
//             const SizedBox(height: 12),
//             TranslatorInfoCard(translatorModel: translatorModel),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grade3/core/utils/app_router.dart';
import 'package:grade3/features/chat/presentation/views/chat_translator_item.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';
import 'package:grade3/features/home/presentation/views/widgets/chat_icon.dart';
import 'package:grade3/features/home/presentation/views/widgets/translator_info_card.dart';
import 'package:grade3/features/home/presentation/views/widgets/translator_logo_name.dart';

class TranslatorCard extends StatelessWidget {
  const TranslatorCard({super.key, required this.translatorModel});
  final TranslatorModel translatorModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context)
            .push(AppRouter.profileView, extra: translatorModel);
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width - 32,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffEBEBEB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TranslatorLogoName(
                  translatorModel: translatorModel,
                ),
                ChatIcon(
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
              ],
            ),
            const SizedBox(height: 12),
            TranslatorInfoCard(translatorModel: translatorModel),
          ],
        ),
      ),
    );
  }
}

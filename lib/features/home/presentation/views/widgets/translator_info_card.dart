import 'package:flutter/material.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';
import 'package:grade3/features/home/presentation/views/widgets/question_answar_column.dart';

class TranslatorInfoCard extends StatelessWidget {
  const TranslatorInfoCard({super.key, required this.translatorModel});
  final TranslatorModel translatorModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuestionAnswarColumn(
          answarFontSize: 12,
          questionFontSize: 10,
          question: 'Location',
          answar: translatorModel.location,
        ),
        QuestionAnswarColumn(
          answarFontSize: 11.3,
          questionFontSize: 9,
          question: 'Languages',
          answar: translatorModel.language.length == 2
              ? "${translatorModel.language[0]}&${translatorModel.language[1]}"
              : translatorModel.language.length == 3
                  ? "${translatorModel.language[0]}&${translatorModel.language[1]}&${translatorModel.language[2]}"
                  : "${translatorModel.language[0]}",
        ),
        QuestionAnswarColumn(
          answarFontSize: 12,
          questionFontSize: 10,
          question: 'Specialization',
          answar: translatorModel.type[0],
        ),
      ],
    );
  }
}

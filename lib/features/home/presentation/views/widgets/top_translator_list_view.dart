// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:translate_hub/core/widgets/custom_error_message.dart';
// import 'package:translate_hub/core/widgets/custom_loading_indicator.dart';
// import 'package:translate_hub/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_cubit.dart';
// import 'package:translate_hub/features/home/presentation/manager/select_language_cubit.dart';
// import 'package:translate_hub/features/home/presentation/views/widgets/translator_card.dart';

// class TopTranslatorListView extends StatelessWidget {
//   const TopTranslatorListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FetchTranslatorsCubit, FetchTranslatorsState>(
//       builder: (context, fetchState) {
//         return BlocBuilder<SelectLanguageCubit, SelectLanguageState>(
//           builder: (context, filterState) {
//             if (fetchState is FetchTranslatorsSuccess) {
//               final cubit = context.read<FetchTranslatorsCubit>();
//               final filteredTranslators =
//                   cubit.translatorsList.where((translator) {
//                 final matchesLanguage = filterState.selectedLanguage == 'all' ||
//                     translator.language.any((lang) => lang
//                         .toLowerCase()
//                         .contains(filterState.selectedLanguage));

//                 final matchesSearch = filterState.searchQuery.isEmpty ||
//                     translator.name
//                         .toLowerCase()
//                         .contains(filterState.searchQuery) ||
//                     translator.language.any((lang) =>
//                         lang.toLowerCase().startsWith(filterState.searchQuery));

//                 return matchesLanguage && matchesSearch;
//               }).toList();

//               return SizedBox(
//                 height: 145,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: filteredTranslators.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 13),
//                       child: TranslatorCard(
//                         translatorModel: filteredTranslators[index],
//                       ),
//                     );
//                   },
//                 ),
//               );
//             } else if (fetchState is FetchTranslatorsFailure) {
//               return CustomErrorMessage(errMessage: fetchState.errMessage);
//             } else {
//               return const CustomLoadingIndicator();
//             }
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/widgets/custom_error_message.dart';
import 'package:grade3/core/widgets/custom_loading_indicator.dart';
import 'package:grade3/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_cubit.dart';
import 'package:grade3/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_state.dart';
import 'package:grade3/features/home/presentation/manager/select_language_cubit.dart';
import 'package:grade3/features/home/presentation/views/widgets/translator_card.dart';

class TopTranslatorListView extends StatelessWidget {
  const TopTranslatorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchTranslatorsCubit, FetchTranslatorsState>(
      builder: (context, fetchState) {
        return BlocBuilder<SelectLanguageCubit, SelectLanguageState>(
          builder: (context, filterState) {
            if (fetchState is FetchTranslatorsSuccess) {
              final cubit = context.read<FetchTranslatorsCubit>();
              final filteredTranslators =
                  cubit.translatorsList.where((translator) {
                final selectedLang =
                    filterState.selectedLanguage.toLowerCase().trim();
                final search = filterState.searchQuery.toLowerCase().trim();

                final matchesLanguage = selectedLang == 'all' ||
                    translator.language.any(
                        (lang) => lang.toLowerCase().contains(selectedLang));

                final matchesSearch = search.isEmpty ||
                    translator.name.toLowerCase().contains(search) ||
                    translator.language
                        .any((lang) => lang.toLowerCase().contains(search));

                return matchesLanguage && matchesSearch;
              }).toList();

              if (filteredTranslators.isEmpty) {
                return const Center(child: Text("No translators found."));
              }

              return SizedBox(
                height: 145,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredTranslators.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 13),
                      child: TranslatorCard(
                        translatorModel: filteredTranslators[index],
                      ),
                    );
                  },
                ),
              );
            } else if (fetchState is FetchTranslatorsFailure) {
              return CustomErrorMessage(errMessage: fetchState.errMessage);
            } else {
              return const CustomLoadingIndicator();
            }
          },
        );
      },
    );
  }
}

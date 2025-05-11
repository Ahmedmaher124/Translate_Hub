// import 'package:bloc/bloc.dart';
// import 'package:translate_hub/features/home/data/models/translator_model.dart';
// import 'package:translate_hub/features/home/data/repos/home_repo.dart';
// import 'package:meta/meta.dart';

// part 'fetch_translators_state.dart';

// class FetchTranslatorsCubit extends Cubit<FetchTranslatorsState> {
//   FetchTranslatorsCubit(this._homeRepo) : super(FetchTranslatorsInitial());
//   final HomeRepo _homeRepo;
//   late List<TranslatorModel> translatorsList;
//   late List<TranslatorModel> filteredTranslatorsList;
//   String _searchQuery = '';

//   Future<void> fetchTranslators() async {
//     emit(FetchTranslatorsLoading());
//     var result = await _homeRepo.fetchTranslators();
//     result.fold(
//       (failure) {
//         emit(
//           FetchTranslatorsFailure(errMessage: failure.errMessage),
//         );
//       },
//       (translators) {
//         translatorsList = translators;
//         filteredTranslatorsList = translators;
//         emit(
//           FetchTranslatorsSuccess(translatorsList: translators),
//         );
//       },
//     );
//   }

//   void searchTranslators(String query) {
//     _searchQuery = query.toLowerCase().trim();

//     if (_searchQuery.isEmpty) {
//       // If search is empty, show all translators
//       filteredTranslatorsList = translatorsList;
//     } else {
//       // Filter by name or language
//       filteredTranslatorsList = translatorsList.where((translator) {
//         // Check if name contains the query
//         final nameMatch = translator.name.toLowerCase().contains(_searchQuery);

//         // Check if any language contains the query
//         final languageMatch = translator.language.any(
//             (lang) => lang.toString().toLowerCase().contains(_searchQuery));

//         // Return true if either name or language matches
//         return nameMatch || languageMatch;
//       }).toList();
//     }

//     // Emit new state with filtered list
//     emit(FetchTranslatorsSuccess(translatorsList: filteredTranslatorsList));
//   }

//   // Clear search and reset to all translators
//   void clearSearch() {
//     _searchQuery = '';
//     filteredTranslatorsList = translatorsList;
//     emit(FetchTranslatorsSuccess(translatorsList: filteredTranslatorsList));
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';
import 'package:grade3/features/home/data/repos/home_repo.dart';
import 'package:grade3/features/home/presentation/manager/fetch_translators_cubit/fetch_translators_state.dart';

class FetchTranslatorsCubit extends Cubit<FetchTranslatorsState> {
  final HomeRepo _homeRepo;

  FetchTranslatorsCubit(this._homeRepo) : super(FetchTranslatorsInitial());

  late List<TranslatorModel> _allTranslators;

  Future<void> fetchTranslators() async {
    emit(FetchTranslatorsLoading());

    final result = await _homeRepo.fetchTranslators();
    result.fold(
      (failure) =>
          emit(FetchTranslatorsFailure(errMessage: failure.errMessage)),
      (translators) {
        _allTranslators = translators;
        _emitCategorizedTranslators(translators);
      },
    );
  }

  void searchTranslators(String query) {
    final trimmedQuery = query.toLowerCase().trim();

    if (trimmedQuery.isEmpty) {
      _emitCategorizedTranslators(_allTranslators);
      return;
    }

    final filtered = _allTranslators.where((translator) {
      final nameMatch = translator.name.toLowerCase().contains(trimmedQuery);
      final languageMatch = translator.language.any(
        (lang) => lang.toString().toLowerCase().contains(trimmedQuery),
      );
      return nameMatch || languageMatch;
    }).toList();

    _emitCategorizedTranslators(filtered);
  }

  void clearSearch() {
    _emitCategorizedTranslators(_allTranslators);
  }

  void _emitCategorizedTranslators(List<TranslatorModel> translators) {
    final immediate = <TranslatorModel>[];
    final emergency = <TranslatorModel>[];
    final editorial = <TranslatorModel>[];

    for (final translator in translators) {
      // تأكد أن المترجم يندرج تحت فئة واحدة فقط
      if (translator.type.contains('emergency') &&
          !emergency.contains(translator)) {
        emergency.add(translator);
      } else if (translator.type.contains('immediate') &&
          !immediate.contains(translator)) {
        immediate.add(translator);
      } else if (translator.type.contains('editorial') &&
          !editorial.contains(translator)) {
        editorial.add(translator);
      }
    }

    emit(FetchTranslatorsSuccess(
      immediateTranslators: immediate,
      emergencyTranslators: emergency,
      editorialTranslators: editorial,
    ));
  }

  List<TranslatorModel> get translatorsList {
    if (state is FetchTranslatorsSuccess) {
      final currentState = state as FetchTranslatorsSuccess;
      return [
        ...currentState.immediateTranslators,
        ...currentState.emergencyTranslators,
        ...currentState.editorialTranslators,
      ];
    }
    return [];
  }
}

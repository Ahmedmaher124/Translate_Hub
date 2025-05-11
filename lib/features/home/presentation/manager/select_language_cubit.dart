import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLanguageCubit extends Cubit<SelectLanguageState> {
  SelectLanguageCubit()
      : super(SelectLanguageState(selectedLanguage: 'all', searchQuery: ''));

  void selectLanguage(String language) {
    emit(state.copyWith(selectedLanguage: language.toLowerCase()));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query.toLowerCase()));
  }
}

class SelectLanguageState {
  final String selectedLanguage;
  final String searchQuery;

  SelectLanguageState({
    required this.selectedLanguage,
    required this.searchQuery,
  });

  SelectLanguageState copyWith({
    String? selectedLanguage,
    String? searchQuery,
  }) {
    return SelectLanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

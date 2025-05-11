// part of 'fetch_translators_cubit.dart';

// @immutable
// sealed class FetchTranslatorsState {}

// final class FetchTranslatorsInitial extends FetchTranslatorsState {}

// final class FetchTranslatorsLoading extends FetchTranslatorsState {}

// final class FetchTranslatorsSuccess extends FetchTranslatorsState {
//   final List<TranslatorModel> translatorsList;

//   FetchTranslatorsSuccess({required this.translatorsList});
// }

// final class FetchTranslatorsFailure extends FetchTranslatorsState {
//   final String errMessage;

//   FetchTranslatorsFailure({required this.errMessage});
// }

import 'package:grade3/features/home/data/models/translator_model.dart';

sealed class FetchTranslatorsState {}

final class FetchTranslatorsInitial extends FetchTranslatorsState {}

final class FetchTranslatorsLoading extends FetchTranslatorsState {}

final class FetchTranslatorsFailure extends FetchTranslatorsState {
  final String errMessage;
  FetchTranslatorsFailure({required this.errMessage});
}

final class FetchTranslatorsSuccess extends FetchTranslatorsState {
  final List<TranslatorModel> immediateTranslators;
  final List<TranslatorModel> emergencyTranslators;
  final List<TranslatorModel> editorialTranslators;

  FetchTranslatorsSuccess({
    required this.immediateTranslators,
    required this.emergencyTranslators,
    required this.editorialTranslators,
  });
}

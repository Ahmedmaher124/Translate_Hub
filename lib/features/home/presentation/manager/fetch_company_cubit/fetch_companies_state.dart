part of 'fetch_companies_cubit.dart';

sealed class FetchCompaniesState {}

final class FetchCompaniesInitial extends FetchCompaniesState {}

final class FetchCompaniesLoading extends FetchCompaniesState {}

final class FetchCompaniesSuccess extends FetchCompaniesState {
  final List<CompanyModel> companiesList;

  FetchCompaniesSuccess({required this.companiesList});
}

final class FetchCompaniesFailure extends FetchCompaniesState {
  final String errMessage;

  FetchCompaniesFailure({required this.errMessage});
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/features/home/data/models/company_model.dart';
import 'package:grade3/features/home/data/repos/home_repo.dart';

part 'fetch_companies_state.dart';

class FetchCompaniesCubit extends Cubit<FetchCompaniesState> {
  FetchCompaniesCubit(this._homeRepo) : super(FetchCompaniesInitial());
  final HomeRepo _homeRepo;
  late List<CompanyModel> companiesList;
  Future<void> fetchCompanies() async {
    emit(FetchCompaniesLoading());
    var result = await _homeRepo.fetchCompanies();
    result.fold(
      (failure) {
        emit(
          FetchCompaniesFailure(errMessage: failure.errMessage),
        );
      },
      (companies) {
        companiesList = companies;
        emit(
          FetchCompaniesSuccess(companiesList: companies),
        );
      },
    );
  }
}

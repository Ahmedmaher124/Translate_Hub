import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:grade3/core/errors/failure.dart';
import 'package:grade3/core/services/api_service.dart';
import 'package:grade3/features/home/data/models/company_model.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';

import 'package:grade3/features/home/data/repos/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final ApiService _apiService;

  HomeRepoImpl({required ApiService apiService}) : _apiService = apiService;
  @override
  Future<Either<Failure, List<CompanyModel>>> fetchCompanies() async {
    try {
      var jsonData = await _apiService.fetchData(
          endPoint: 'company/list-companies?page=1&limit=10');
      List<CompanyModel> companyList = [];
      for (var item in jsonData['companies']) {
        companyList.add(
          CompanyModel.fromJson(item),
        );
      }
      return right(companyList);
    } catch (e) {
      if (e is DioException) {
        return left(
          ServerFailure.fromDioError(e),
        );
      }
      return left(
        ServerFailure(
          errMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<TranslatorModel>>> fetchTranslators() async {
    try {
      var jsonData = await _apiService.fetchData(endPoint: 'translator/list');
      List<TranslatorModel> translatorsList = [];
      for (var item in jsonData['translators']) {
        translatorsList.add(TranslatorModel.fromJson(item));
      }
      return right(translatorsList);
    } catch (e) {
      if (e is DioException) {
        return left(
          ServerFailure.fromDioError(e),
        );
      }
      return left(
        ServerFailure(
          errMessage: e.toString(),
        ),
      );
    }
  }
}

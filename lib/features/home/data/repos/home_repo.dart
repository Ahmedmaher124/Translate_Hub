import 'package:dartz/dartz.dart';
import 'package:grade3/core/errors/failure.dart';
import 'package:grade3/features/home/data/models/company_model.dart';
import 'package:grade3/features/home/data/models/translator_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<CompanyModel>>> fetchCompanies();
  Future<Either<Failure, List<TranslatorModel>>> fetchTranslators();
}

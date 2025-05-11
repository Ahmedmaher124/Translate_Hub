import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  Failure({required this.errMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errMessage});
  factory ServerFailure.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.unknown:
        return ServerFailure(errMessage: 'UnExpected Error, please try later');
      case DioExceptionType.sendTimeout:
        return ServerFailure(
            errMessage: 'Send Time Out with Server, please try again');
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
            errMessage: 'Receive Time Out with Server, please try again');
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
            errMessage: 'Connection Time Out with Server, please try again');
      case DioExceptionType.connectionError:
        return ServerFailure(
            errMessage:
                'Internet Connection Error with Server, please try again');
      case DioExceptionType.cancel:
        return ServerFailure(
            errMessage:
                'Your Request was canceled with Server, please try again');
      case DioExceptionType.badResponse:
        return ServerFailure.fromBadRespons(
          dioException.response!.statusCode!,
          dioException.response!.data!,
        );
      default:
        return ServerFailure(
            errMessage: 'oops there was an error,please try later');
    }
  }

  factory ServerFailure.fromBadRespons(int statusCode, dynamic badResponse) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(errMessage: badResponse['message']);
    } else if (statusCode == 404) {
      return ServerFailure(
          errMessage: 'Your request not found,please try again');
    } else if (statusCode == 500) {
      return ServerFailure(
          errMessage: 'Internal Server error, please try later');
    } else {
      return ServerFailure(
          errMessage: 'oops there was an error,please try again');
    }
  }
}

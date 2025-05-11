import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  final String _baseUrl = 'https://translator-project-seven.vercel.app/';
  ApiService({required Dio dio}) : _dio = dio;
  Future<Map<String, dynamic>> fetchData({required String endPoint}) async {
    Response response = await _dio.get('$_baseUrl$endPoint');
    var jsonData = response.data;
    return jsonData;
  }
}

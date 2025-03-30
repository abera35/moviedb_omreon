import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = dotenv.env['TMDB_BASE_URL']!;
    _dio.options.queryParameters = {
      'api_key': dotenv.env['TMDB_API_KEY'],
    };
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Dio get client => _dio;
}
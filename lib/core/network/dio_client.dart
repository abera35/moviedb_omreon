import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = dotenv.env['TMDB_BASE_URL']!;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['TMDB_API_KEY']}',
    };
  }

  Dio get client => _dio;
}

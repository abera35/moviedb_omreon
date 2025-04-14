import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    final baseUrl = dotenv.env['TMDB_BASE_URL'];
    final apiKey = dotenv.env['TMDB_API_KEY'];

    if (baseUrl == null || apiKey == null) {
      throw Exception('TMDB_BASE_URL or TMDB_API_KEY is not set in .env');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        queryParameters: {'api_key': apiKey},
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  Dio get client => _dio;
}

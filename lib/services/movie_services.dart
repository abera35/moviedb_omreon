import '../core/network/dio_client.dart';
import '../models/movie_model.dart';

class MovieService {
  final DioClient _client;

  MovieService(this._client);

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await _client.client.get('/movie/popular');
      final List results = response.data['results'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error - Could not get movies from service: $e');
    }
  }
}
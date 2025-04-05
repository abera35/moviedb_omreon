import 'package:moviedb_omreon/models/movie_model_detail.dart';

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

  Future<MovieDetail> fetchMovieDetail(String movieId) async {
    final response = await _client.client.get('/movie/$movieId');

    if (response.statusCode == 200) {
      return MovieDetail.fromJson(response.data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await _client.client.get('/search/movie', queryParameters: {'query': query});
      final List results = response.data['results'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error - Could not search movies: $e');
    }
  }
}

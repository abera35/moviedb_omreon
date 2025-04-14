import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_omreon/models/movie_model.dart';
import 'package:moviedb_omreon/services/favorite_service.dart';

class FavoriteCubit extends Cubit<List<Movie>> {
  final FavoriteService _service;

  FavoriteCubit(this._service) : super([]) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favorites = await _service.loadFavorites();
    emit(favorites);
  }

  void toggleFavorite(Movie movie) {
    final isFav = isFavorite(movie.id);
    isFav ? removeFavorite(movie.id) : addFavorite(movie);
  }

  bool isFavorite(int movieId) {
    return state.any((m) => m.id == movieId);
  }

  Future<void> addFavorite(Movie movie) async {
    await _service.addFavorite(movie);
    loadFavorites();
  }

  Future<void> removeFavorite(int movieId) async {
    await _service.removeFavorite(movieId);
    loadFavorites();
  }
}

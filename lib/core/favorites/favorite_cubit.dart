import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_omreon/models/movie_model.dart';
import 'package:moviedb_omreon/services/favorite_service.dart';

class FavoriteCubit extends Cubit<List<Movie>> {
  final FavoriteService _service;

  FavoriteCubit(this._service) : super([]) {
    loadFavorites();
  }

  void loadFavorites() async {
    final favorites = await _service.loadFavorites();
    emit(favorites);
  }

  void toggleFavorite(Movie movie) async {
    final isFav = state.any((m) => m.id == movie.id);
    if (isFav) {
      await _service.removeFavorite(movie.id);
    } else {
      await _service.addFavorite(movie);
    }
    loadFavorites();
  }

  bool isFavorite(int movieId) {
    return state.any((m) => m.id == movieId);
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moviedb_omreon/models/movie_model.dart';

class FavoriteService {
  static const String _key = 'favorites';
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveFavorites(List<Movie> movies) async {
    final prefs = await _instance;
    final movieList = movies.map((movie) => jsonEncode(movie.toJson())).toList();
    await prefs.setStringList(_key, movieList);
  }

  Future<List<Movie>> loadFavorites() async {
    try {
      final prefs = await _instance;
      final movieList = prefs.getStringList(_key) ?? [];
      return movieList.map((str) => Movie.fromJson(jsonDecode(str))).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addFavorite(Movie movie) async {
    final favorites = await loadFavorites();
    if (!favorites.any((m) => m.id == movie.id)) {
      favorites.add(movie);
      await saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(int movieId) async {
    final favorites = await loadFavorites();
    favorites.removeWhere((m) => m.id == movieId);
    await saveFavorites(favorites);
  }

  Future<bool> isFavorite(int movieId) async {
    final favorites = await loadFavorites();
    return favorites.any((m) => m.id == movieId);
  }
}

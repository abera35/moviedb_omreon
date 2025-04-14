import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_omreon/models/movie_model.dart';
import 'package:moviedb_omreon/services/movie_service.dart';
import 'package:rxdart/rxdart.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieService _movieService;
  List<Movie> _lastSearchedMovies = [];
  String _lastQuery = '';

  MovieBloc(this._movieService) : super(MovieInitial()) {
    on<FetchPopularMovies>(_onFetchPopularMovies);
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<SearchMovies>(_onSearchMovies, transformer: debounce(const Duration(milliseconds: 500)));
  }

  Future<void> _onFetchPopularMovies(FetchPopularMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await _movieService.getPopularMovies();
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError('Error - While loading the movies: $e'));
    }
  }

  Future<void> _onFetchMovieDetail(FetchMovieDetail event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movie = await _movieService.fetchMovieDetail(event.movieId);
      emit(MovieDetailLoaded(movie));
    } catch (e) {
      emit(MovieError('Failed to load movie details:  $e'));
    }
  }

  Future<void> _onSearchMovies(SearchMovies event, Emitter<MovieState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) return;

    if (query == _lastQuery && _lastSearchedMovies.isNotEmpty) {
      emit(MovieLoaded(_lastSearchedMovies));
      return;
    }

    emit(MovieLoading());
    try {
      final movies = await _movieService.searchMovies(query);
      _lastQuery = query;
      _lastSearchedMovies = movies;
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError('Search failed: $e'));
    }
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  List<Movie> get lastSearchedMovies => _lastSearchedMovies;
  String get lastQuery => _lastQuery;
}

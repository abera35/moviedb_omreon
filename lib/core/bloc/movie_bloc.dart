import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_omreon/services/movie_services.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieService _movieService;

  MovieBloc(this._movieService) : super(MovieInitial()) {
    on<FetchPopularMovies>(_onFetchPopularMovies);
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
}

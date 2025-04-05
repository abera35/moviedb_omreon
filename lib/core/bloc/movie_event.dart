import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPopularMovies extends MovieEvent {}

class FetchMovieDetail extends MovieEvent {
  final String movieId;
  FetchMovieDetail(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class SearchMovies extends MovieEvent {
  final String query;
  SearchMovies(this.query);

  @override
  List<Object> get props => [query];
}

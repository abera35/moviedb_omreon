import 'package:equatable/equatable.dart';
import 'package:moviedb_omreon/models/movie_model_detail.dart';
import '../../models/movie_model.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  MovieLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class MovieDetailLoaded extends MovieState {
  final MovieDetail movie;
  MovieDetailLoaded(this.movie);

  @override
  List<Object> get props => [movie]; 
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieSearchLoaded extends MovieState {
  final List<Movie> movies;
  MovieSearchLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

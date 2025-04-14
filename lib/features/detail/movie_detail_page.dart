import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_omreon/core/bloc/movie_bloc.dart';
import 'package:moviedb_omreon/core/bloc/movie_event.dart';
import 'package:moviedb_omreon/core/bloc/movie_state.dart';
import 'package:moviedb_omreon/core/favorites/favorite_cubit.dart';
import 'package:moviedb_omreon/core/widgets/error_widget.dart';
import 'package:moviedb_omreon/core/widgets/loading_widget.dart';
import 'package:moviedb_omreon/models/movie_model.dart';
import 'package:moviedb_omreon/models/movie_model_detail.dart';

class MovieDetailPage extends StatefulWidget {
  final String movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMovieDetail(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Movie Details")),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const CustomLoadingWidget();
          } else if (state is MovieDetailLoaded) {
            return _buildMovieDetail(state.movie);
          } else if (state is MovieError) {
            return CustomErrorWidget(message: state.message);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildMovieDetail(MovieDetail movie) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MoviePoster(posterPath: movie.posterPath),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow),
                    const SizedBox(width: 4),
                    Text(movie.voteAverage.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: movie.genres.map((genre) => Chip(label: Text(genre.name))).toList()),
                const SizedBox(height: 8),
                Text(movie.overview, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),

                BlocBuilder<FavoriteCubit, List<Movie>>(
                  builder: (context, favorites) {
                    final movieToFavorite = Movie(
                      id: movie.id,
                      title: movie.title,
                      posterPath: movie.posterPath,
                      overview: movie.overview,
                      vote_average: movie.voteAverage,
                    );

                    final isFav = context.read<FavoriteCubit>().isFavorite(movie.id);

                    return ElevatedButton.icon(
                      onPressed: () {
                        context.read<FavoriteCubit>().toggleFavorite(movieToFavorite);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isFav ? '${movie.title} removed from Favorites' : '${movie.title} added to Favorites' , )),
                        );
                      },
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                      label: Text(isFav ? "Remove from Favorites" : "Add to Favorites"),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final String posterPath;

  const _MoviePoster({required this.posterPath});

  @override
  Widget build(BuildContext context) {
    return posterPath != ''
        ? Image.network('https://image.tmdb.org/t/p/w500$posterPath', width: double.infinity, fit: BoxFit.cover)
        : Image.asset('assets/images/png/image_not_found.png', width: double.infinity, fit: BoxFit.cover);
  }
}

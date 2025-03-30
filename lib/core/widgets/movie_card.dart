import 'package:flutter/material.dart';
import '../../models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: movie.posterPath != null
            ? Image.network(
                'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                fit: BoxFit.cover,
              )
            : Icon(Icons.movie),
        title: Text(movie.title),
        subtitle: Text(movie.overview, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

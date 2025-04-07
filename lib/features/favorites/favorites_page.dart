import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moviedb_omreon/core/favorites/favorite_cubit.dart';
import 'package:moviedb_omreon/models/movie_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: BlocBuilder<FavoriteCubit, List<Movie>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final movie = favorites[index];
              final isFav = context.read<FavoriteCubit>().isFavorite(movie.id);
              return ListTile(
                leading:
                    movie.posterPath != null
                        ? Image.network('https://image.tmdb.org/t/p/w92${movie.posterPath}')
                        : Image.asset('assets/images/png/image_not_found.png'),
                title: Text(movie.title),
                subtitle: Text(movie.overview, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFav ? '${movie.title} removed from Favorites' : '${movie.title} added to Favorites',
                          ),
                        ),
                      );
                      context.read<FavoriteCubit>().toggleFavorite(movie);
                    },
                  ),
                ),
                onTap: () => context.push('/detail/${movie.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

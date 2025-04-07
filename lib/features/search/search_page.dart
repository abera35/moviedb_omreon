import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moviedb_omreon/core/bloc/movie_bloc.dart';
import 'package:moviedb_omreon/core/bloc/movie_event.dart';
import 'package:moviedb_omreon/core/bloc/movie_state.dart';
import 'package:moviedb_omreon/models/movie_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<MovieBloc>();

    if (bloc.lastQuery.isNotEmpty && bloc.lastSearchedMovies.isNotEmpty) {
      _controller.text = bloc.lastQuery;

      bloc.add(SearchMovies(bloc.lastQuery));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              onChanged: (query) {
                context.read<MovieBloc>().add(SearchMovies(query));
              },
              decoration: InputDecoration(
                hintText: 'Search movies...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final bloc = context.read<MovieBloc>();
                final state = context.watch<MovieBloc>().state;

                final movies =
                    (state is MovieLoaded && state.movies.isNotEmpty) ? state.movies : bloc.lastSearchedMovies;

                if (state is MovieLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (movies.isNotEmpty) {
                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () => context.push('/detail/${movie.id}'),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(borderRadius: BorderRadius.circular(8), child: _PosterWithNullCheck(movie)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _TitleAndOverview(movie: movie, isTitle: true),
                                      const SizedBox(height: 8),
                                      _TitleAndOverview(movie: movie, isTitle: false),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is MovieError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Movies not found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Image _PosterWithNullCheck(Movie movie) {
    return Image.network(
      'https://image.tmdb.org/t/p/w92${movie.posterPath}',
      width: 92,
      height: 138,
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) =>
              Image.asset('assets/images/png/image_not_found.png', width: 92, height: 138, fit: BoxFit.cover),
    );
  }
}

class _TitleAndOverview extends StatelessWidget {
  const _TitleAndOverview({required this.movie, required this.isTitle});

  final Movie movie;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    return isTitle == true
        ? Text(
          movie.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )
        : Text(movie.overview, style: const TextStyle(fontSize: 14), maxLines: 4, overflow: TextOverflow.ellipsis);
  }
}

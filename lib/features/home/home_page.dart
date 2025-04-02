import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_omreon/core/bloc/movie_event.dart';
import 'package:moviedb_omreon/services/movie_services.dart';
import '../../core/bloc/movie_bloc.dart';
import '../../core/bloc/movie_state.dart';
import '../../core/widgets/movie_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(context.read<MovieService>())..add(FetchPopularMovies()),
      child: Scaffold(
        appBar: AppBar(title: Text('Popular Movies')),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieInitial) {
              context.read<MovieBloc>().add(FetchPopularMovies());
              return const Center(child: CircularProgressIndicator(),);
            }
            else if (state is MovieLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded) {
              return ListView.builder(
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  return MovieCard(movie: state.movies[index]);
                },
              );
            } else if (state is MovieError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
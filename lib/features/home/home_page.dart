import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_omreon/core/bloc/movie_event.dart';
import 'package:moviedb_omreon/core/widgets/error_widget.dart';
import 'package:moviedb_omreon/core/widgets/loading_widget.dart';
import 'package:moviedb_omreon/services/movie_service.dart';
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
            if (state is MovieLoading || state is MovieInitial) {
              context.read<MovieBloc>().add(FetchPopularMovies());
              return CustomLoadingWidget();
            } else if (state is MovieLoaded) {
              return ListView.builder(
                itemCount: state.movies.length,
                itemBuilder: (context, index) => MovieCard(movie: state.movies[index]),
              );
            } else if (state is MovieError) {
              return CustomErrorWidget(message: state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

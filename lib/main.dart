import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviedb_omreon/core/bloc/movie_event.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_omreon/features/home/home_page.dart';
import 'package:moviedb_omreon/services/movie_services.dart';
import 'package:moviedb_omreon/core/network/dio_client.dart';
import 'package:moviedb_omreon/core/bloc/movie_bloc.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DioClient>(create: (_) => DioClient()),
        Provider<MovieService>(
          create: (context) => MovieService(context.read<DioClient>()),
        ),
        BlocProvider<MovieBloc>(
          create: (context) => MovieBloc(context.read<MovieService>())..add(FetchPopularMovies()),
        ),
      ],
      child: MaterialApp(
        title: 'MovieDB Omreon',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomePage(),
      ),
    );
  }
}
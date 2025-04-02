import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:moviedb_omreon/core/bloc/movie_event.dart';
import 'package:moviedb_omreon/features/detail/movie_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_omreon/features/home/home_page.dart';
import 'package:moviedb_omreon/features/search/search_page.dart';
import 'package:moviedb_omreon/features/favorites/favorites_page.dart';
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
        Provider<MovieService>(create: (context) => MovieService(context.read<DioClient>())),
        BlocProvider<MovieBloc>(
          create: (context) => MovieBloc(context.read<MovieService>())..add(FetchPopularMovies()),
        ),
      ],
      child: MaterialApp.router(
        title: 'MovieDB Omreon',
        theme: ThemeData.dark(),
        routerConfig: _router,
        debugShowCheckedModeBanner: false
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => MainScreen()),
    GoRoute(path: '/search', builder: (context, state) => SearchPage()),
    GoRoute(path: '/favorites', builder: (context, state) => FavoritesPage()),
    GoRoute(path: '/detail/:id', builder: (context, state) {
      final movieId = state.pathParameters['id'];
      // if (movieId == null) {
      //   return ErrorPage();
      // }
      return MovieDetailPage(movieId: movieId ?? '');
    },)
  ],
);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<String> _routes = ['/', '/search', '/favorites'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: [HomePage(), SearchPage(), FavoritesPage()]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}

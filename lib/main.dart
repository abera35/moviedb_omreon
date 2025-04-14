import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:moviedb_omreon/core/bloc/movie_event.dart';
import 'package:moviedb_omreon/core/favorites/favorite_cubit.dart';
import 'package:moviedb_omreon/features/detail/movie_detail_page.dart';
import 'package:moviedb_omreon/services/favorite_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb_omreon/features/home/home_page.dart';
import 'package:moviedb_omreon/features/search/search_page.dart';
import 'package:moviedb_omreon/features/favorites/favorites_page.dart';
import 'package:moviedb_omreon/services/movie_service.dart';
import 'package:moviedb_omreon/core/network/dio_client.dart';
import 'package:moviedb_omreon/core/bloc/movie_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        BlocProvider<FavoriteCubit>(create: (_) => FavoriteCubit(FavoriteService())),
      ],
      child: MaterialApp.router(
        title: 'MovieDB Omreon',
        theme: ThemeData.dark(),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
        GoRoute(path: '/favorites', builder: (context, state) => const FavoritesPage()),
        GoRoute(
          path: '/detail/:id',
          builder: (context, state) {
            final movieId = state.pathParameters['id'];
            return MovieDetailPage(movieId: movieId ?? '');
          },
        ),
      ],
    ),
  ],
);

class MainScreen extends StatefulWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<String> _routes = ['/home', '/search', '/favorites'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_routes[index]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final location = GoRouterState.of(context).uri.toString();
    final index = _routes.indexWhere((r) => location.startsWith(r));

    if (index != -1 && index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child, 
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

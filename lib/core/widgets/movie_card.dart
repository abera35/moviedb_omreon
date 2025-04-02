import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push('/detail/${movie.id}');
      },
      child: Padding(
        padding: _VariablesForCard._paddingCardSymmetric,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: _VariablesForCard._normalBorderRadiusCircular),
          child: Stack(
            children: [
              _MovieImage(movie: movie),
              _GradientOverlay(),
              Positioned(bottom: 10, left: 10, right: 10, child: _MovieInfo(movie: movie)),
            ],
          ),
        ),
      ),
    );
  }
}

class _VariablesForCard {
  static const double _cardHeight = 250;
  static final BorderRadius _normalBorderRadiusCircular = BorderRadius.circular(12);
  static const String _imageBaseLink = 'https://image.tmdb.org/t/p/w500';
  static const EdgeInsets _paddingCardSymmetric = EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
}

class _MovieImage extends StatelessWidget {
  final Movie movie;
  const _MovieImage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _VariablesForCard._normalBorderRadiusCircular,
      child: Image.network(
        '${_VariablesForCard._imageBaseLink}${movie.posterPath}',
        width: double.infinity,
        height: _VariablesForCard._cardHeight,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _VariablesForCard._cardHeight,
      decoration: BoxDecoration(
        borderRadius: _VariablesForCard._normalBorderRadiusCircular,
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
        ),
      ),
    );
  }
}

class _MovieInfo extends StatelessWidget {
  final Movie movie;
  const _MovieInfo({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          movie.overview,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.yellow, size: 18),
            const SizedBox(width: 4),
            Text(movie.vote_average.toStringAsFixed(1), style: const TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moviedb_omreon/core/constants/ui_constants.dart';
import '../../models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/detail/${movie.id}');
      },
      child: Padding(
        padding: UIConstants.paddingCardSymmetric,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: UIConstants.normalBorderRadiusCircular),
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

class _MovieImage extends StatelessWidget {
  final Movie movie;
  const _MovieImage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: UIConstants.normalBorderRadiusCircular,
      child:
          movie.posterPath != null
              ? Image.network(
                '${UIConstants.imageBaseLink}${movie.posterPath}',
                width: double.infinity,
                height: UIConstants.cardHeight,
                fit: BoxFit.cover,
              )
              : NotFoundImage(),
    );
  }
}

// class ImageItems {
//   final String imageNotFound = 'image_not_found';
// }

// class NotFoundImage extends StatelessWidget {
//   final String name;
//   const NotFoundImage({super.key, required this.name});
//   @override
//   Widget build(BuildContext context) {
//     return Image.asset(_nameWithPath, fit: BoxFit.cover, height: UIConstants.cardHeight, width: double.infinity);
//   }

//   String get _nameWithPath => 'assets/images/png/$name.png';
// }

class NotFoundImage extends StatelessWidget {
  const NotFoundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/png/image_not_found.png',
      fit: BoxFit.cover,
      height: UIConstants.cardHeight,
      width: double.infinity,
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: UIConstants.cardHeight,
      decoration: BoxDecoration(
        borderRadius: UIConstants.normalBorderRadiusCircular,
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
        RatingRow(rating: movie.vote_average),
      ],
    );
  }
}

class RatingRow extends StatelessWidget {
  final double rating;

  const RatingRow({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.yellow, size: 18),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class MovieDetail {
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final List<Genre> genres;

  MovieDetail({
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.genres,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      genres: (json['genres'] as List).map((g) => Genre.fromJson(g)).toList(),
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'], name: json['name']);
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class Movie {
  final int id;
  final String title;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  final String overview;
  final double vote_average;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    required this.overview,
    required this.vote_average,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

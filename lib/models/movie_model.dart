import 'package:eiga/models/category_model.dart';
import 'package:eiga/models/movie_artist_model.dart';
import 'package:eiga/models/nationality_model.dart';
import 'package:eiga/models/saga_model.dart';

class MovieModel {
  final int id;
  final String title;
  final String imageName;
  final String synopsis;
  final int? duration;
  final String? trailerUrl;
  final DateTime? releaseDate;
  final String? videoName;
  final SagaModel? saga;
  final List<CategoryModel>? categories;
  final List<NationalityModel>? nationalities;
  final List<MovieArtistModel>? artists;

  MovieModel({
    required this.id,
    required this.title,
    required this.imageName,
    required this.synopsis,
    this.duration,
    this.trailerUrl,
    this.releaseDate,
    this.videoName,
    this.saga,
    this.categories,
    this.nationalities,
    this.artists,
  });

  bool get isComplete {
    return ![
      id,
      title,
      imageName,
      synopsis,
      duration,
      trailerUrl,
      releaseDate,
      videoName,
      saga,
      categories,
      nationalities,
      artists,
    ].any((e) => e == null || e is List && e.isEmpty);
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      imageName: json['image_name'],
      synopsis: json['synopsis'],
      duration: json['duration'],
      trailerUrl: json['trailer_url'],
      releaseDate:
          json['release_date'] != null
              ? DateTime.parse(json['release_date'])
              : null,
      videoName: json['video_name'],
      saga: json['saga'] != null ? SagaModel.fromJson(json['saga']) : null,
      categories:
          json['categories'] != null && json['categories'].isNotEmpty
              ? List<CategoryModel>.from(
                json['categories'].map((x) => CategoryModel.fromJson(x)),
              )
              : null,
      nationalities:
          json['nationalities'] != null && json['nationalities'].isNotEmpty
              ? List<NationalityModel>.from(
                json['nationalities'].map((x) => NationalityModel.fromJson(x)),
              )
              : null,
      artists:
          json['artists'] != null && json['artists'].isNotEmpty
              ? List<MovieArtistModel>.from(
                json['artists'].map((x) => MovieArtistModel.fromJson(x)),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_name': imageName,
      'synopsis': synopsis,
      'duration': duration,
      'trailer_url': trailerUrl,
      'release_date': releaseDate,
      'video_name': videoName,
      'saga': saga?.toJson(),
      'categories': categories?.map((e) => e.toJson()).toList(),
      'nationalities': nationalities?.map((e) => e.toJson()).toList(),
      'artists': artists?.map((e) => e.toJson()).toList(),
    };
  }
}

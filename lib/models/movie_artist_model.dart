import 'package:eiga/models/job_model.dart';

class MovieArtistModel {
  final int id;
  final String name;
  final JobModel job;

  MovieArtistModel({required this.id, required this.name, required this.job});

  factory MovieArtistModel.fromJson(Map<String, dynamic> json) {
    return MovieArtistModel(
      id: json['id'],
      name: json['name'],
      job: JobModel.fromJson(json['job']),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

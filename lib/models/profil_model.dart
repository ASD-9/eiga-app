import 'package:eiga/models/avatar_model.dart';

class ProfilModel {
  final int id;
  final String name;
  final AvatarModel avatar;

  ProfilModel({required this.id, required this.name, required this.avatar});

  factory ProfilModel.fromJson(Map<String, dynamic> json) {
    return ProfilModel(
      id: json['id'],
      name: json['name'],
      avatar: AvatarModel.fromJson(json['avatar']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar.toJson(),
  };
}

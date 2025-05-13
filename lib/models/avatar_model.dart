class AvatarModel {
  final int id;
  final String name;
  final String imageName;

  AvatarModel({required this.id, required this.name, required this.imageName});

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      id: json['id'],
      name: json['name'],
      imageName: json['image_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image_name': imageName,
  };
}

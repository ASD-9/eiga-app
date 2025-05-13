class NationalityModel {
  final int id;
  final String name;

  NationalityModel({required this.id, required this.name});

  factory NationalityModel.fromJson(Map<String, dynamic> json) {
    return NationalityModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

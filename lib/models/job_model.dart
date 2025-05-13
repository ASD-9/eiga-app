class JobModel {
  final int id;
  final String name;

  JobModel({required this.id, required this.name});

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

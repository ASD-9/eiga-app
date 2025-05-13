class SagaModel {
  final int id;
  final String name;

  SagaModel({required this.id, required this.name});

  factory SagaModel.fromJson(Map<String, dynamic> json) {
    return SagaModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

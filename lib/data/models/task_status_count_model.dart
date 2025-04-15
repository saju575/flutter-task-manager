class TaskStatusCountModel {
  final String id;
  final int sum;

  TaskStatusCountModel({required this.id, required this.sum});

  factory TaskStatusCountModel.fromJson(Map<String, dynamic> json) =>
      TaskStatusCountModel(id: json["_id"] ?? "", sum: json["sum"] ?? "");

  Map<String, dynamic> toJson() => {"id": id, "sum": sum};
}

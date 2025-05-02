class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String email;
  final String createdDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.email,
    required this.createdDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'] ?? "",
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      email: json['email'] ?? "",
      createdDate: json['createdDate'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['status'] = status;
    data['email'] = email;
    data['createdDate'] = createdDate;
    return data;
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? email,
    String? createdDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      email: email ?? this.email,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}

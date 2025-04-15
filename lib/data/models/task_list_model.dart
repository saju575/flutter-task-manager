import 'package:task_manager/data/models/task_model.dart';

class TaskListModel {
  final String status;
  final List<TaskModel> data;

  TaskListModel({required this.status, required this.data});

  factory TaskListModel.fromJson(Map<String, dynamic> json) {
    return TaskListModel(
      status: json['status'],
      data: List<TaskModel>.from(
        json['data'].map((x) => TaskModel.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

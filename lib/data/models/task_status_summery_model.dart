import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';

class TaskStatusSummeryModel {
  final String status;
  final List<TaskStatusCountModel> data;

  TaskStatusSummeryModel({required this.status, required this.data});

  factory TaskStatusSummeryModel.fromJson(Map<String, dynamic> json) =>
      TaskStatusSummeryModel(
        status: json["status"],
        data: List<TaskStatusCountModel>.from(
          json["data"].map((x) => TaskStatusCountModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

  int get totalCompletedTasks {
    try {
      return data
          .firstWhere((element) => element.id == TaskStatus.completed.label)
          .sum;
    } catch (e) {
      return 0;
    }
  }

  int get totalNewTasks {
    try {
      return data
          .firstWhere((element) => element.id == TaskStatus.newTask.label)
          .sum;
    } catch (e) {
      return 0;
    }
  }

  int get totalProgressTasks {
    try {
      return data
          .firstWhere((element) => element.id == TaskStatus.progress.label)
          .sum;
    } catch (e) {
      return 0;
    }
  }

  int get totalCancelledTasks {
    try {
      return data
          .firstWhere((element) => element.id == TaskStatus.canceled.label)
          .sum;
    } catch (e) {
      return 0;
    }
  }
}

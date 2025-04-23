import 'package:task_manager/data/enums/task_status.dart';

TaskStatus getTaskStatus(String status) {
  switch (status) {
    case "New":
      return TaskStatus.newTask;
    case "Progress":
      return TaskStatus.progress;
    case "Completed":
      return TaskStatus.completed;
    case "Canceled":
      return TaskStatus.canceled;
    default:
      return TaskStatus.newTask;
  }
}

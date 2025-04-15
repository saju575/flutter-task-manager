import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_status_summery_model.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/data/enums/task_status.dart';

class TaskController {
  static TaskStatusSummeryModel? taskStatusSummery;
  static TaskListModel? newTaskList;
  static String taskSummeryError = '';

  static Future<void> getTaskStatusSummery() async {
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.taskStatusSummery,
      token: true,
    );
    if (response.isSuccess) {
      taskStatusSummery = TaskStatusSummeryModel.fromJson(response.data);
    } else {
      taskSummeryError = response.errorMessage;
    }
  }

  static Future<void> getNewTaskList() async {
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.getLaskListByStatus(TaskStatus.newTask.label),
      token: true,
    );
    if (response.isSuccess) {
      newTaskList = TaskListModel.fromJson(response.data);
    }
  }
}

import 'package:get/get.dart';
import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/task_controller.dart';

class AddNewTaskController extends GetxController {
  final NetworkClient _networkClient;
  final TaskController _taskController;

  AddNewTaskController({
    required NetworkClient networkClient,
    required TaskController taskController,
  }) : _networkClient = networkClient,
       _taskController = taskController;

  bool _addNewTaskInProgress = false;
  String? _errorMessage;

  bool get addNewTaskInProgress => _addNewTaskInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> addNewTask({
    required String subject,
    required String description,
  }) async {
    _errorMessage = null;
    _addNewTaskInProgress = true;
    update();

    Map<String, dynamic> responsBody = {
      "title": subject,
      "description": description,
      "status": TaskStatus.newTask.label,
    };

    NetworkResponse response = await _networkClient.postRequest(
      url: Urls.createTask,
      body: responsBody,
      token: true,
    );
    if (response.isSuccess) {
      _taskController.insertTaskOptimistically(
        TaskStatus.newTask,
        TaskModel.fromJson(response.data["data"]),
      );
    } else {
      _errorMessage = response.errorMessage;
    }
    _addNewTaskInProgress = false;
    update();
    return response.isSuccess;
  }
}

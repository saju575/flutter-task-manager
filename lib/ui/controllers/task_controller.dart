import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/task_status_summery_model.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/data/enums/task_status.dart';

class TaskController extends GetxController {
  final NetworkClient _networkClient;
  TaskController({required NetworkClient networkClient})
    : _networkClient = networkClient;

  TaskStatusSummeryModel? _taskStatusSummery;
  bool _isTaskStatusSummeryLoading = false;
  String? _taskSummeryError;
  String? _taskDeleteError;
  String? _taskStatusUpdateError;
  bool _isTaskDeleteLoading = false;
  bool _isTaskStatusUpdating = false;

  final Map<TaskStatus, TaskListModel> _taskListData = {};
  final Map<TaskStatus, String?> _errors = {};
  final Map<TaskStatus, bool> _loadings = {
    for (var status in TaskStatus.values) status: false,
  };

  bool get isTaskStatusSummeryLoading => _isTaskStatusSummeryLoading;
  TaskStatusSummeryModel? get taskStatusSummery => _taskStatusSummery;
  String? get taskSummeryError => _taskSummeryError;
  String? get taskDeleteError => _taskDeleteError;
  bool get isTaskDeleteLoading => _isTaskDeleteLoading;
  String? get taskStatusUpdateError => _taskStatusUpdateError;
  bool get isTaskStatusUpdating => _isTaskStatusUpdating;

  TaskListModel? getTaskList(TaskStatus status) =>
      _taskListData[status]; // getTaskList
  String? getError(TaskStatus status) => _errors[status];
  bool getLoading(TaskStatus status) => _loadings[status] ?? false;

  Future<void> _getTaskStatusSummery() async {
    NetworkResponse response = await _networkClient.getRequest(
      url: Urls.taskStatusSummery,
      token: true,
    );
    if (response.isSuccess) {
      _taskStatusSummery = TaskStatusSummeryModel.fromJson(response.data);
    } else {
      _taskSummeryError = response.errorMessage;
    }
  }

  Future<void> getInitialTaskStatusSummery() async {
    _taskSummeryError = null;
    _isTaskStatusSummeryLoading = true;
    update();
    await _getTaskStatusSummery();
    _isTaskStatusSummeryLoading = false;
    update();
  }

  Future<void> refreshTaskStatusSummery() async {
    _taskSummeryError = null;
    update();
    await _getTaskStatusSummery();
    update();
  }

  Future<void> _getTaskList({required TaskStatus status}) async {
    NetworkResponse response = await _networkClient.getRequest(
      url: Urls.getLaskListByStatus(status.label),
      token: true,
    );
    if (response.isSuccess) {
      _taskListData[status] = TaskListModel.fromJson(response.data);
    } else {
      _setError(status, response.errorMessage);
    }
  }

  Future<void> initialFetchTaskList({required TaskStatus status}) async {
    _setError(status, null);
    _setLoading(status, true);
    update();
    await _getTaskList(status: status);
    _setLoading(status, false);
    update();
  }

  Future<void> refreshTaskList({required TaskStatus status}) async {
    _setError(status, null);
    update();
    await _getTaskList(status: status);
    update();
  }

  void insertTaskOptimistically(TaskStatus status, TaskModel task) {
    final list = _taskListData[status];
    if (list != null) {
      list.data.add(task); // insert at top
    } else {
      _taskListData[status] = TaskListModel(status: "success", data: [task]);
    }
    update();
    refreshTaskStatusSummery();
  }

  void removeTaskOptimistically(TaskStatus status, String id) {
    final list = _taskListData[status];
    if (list != null) {
      list.data.removeWhere((task) => task.id == id);
    }
    update();
    refreshTaskStatusSummery();
  }

  void updateTaskStatusOptimistically({
    required TaskStatus prevStatus,
    required TaskStatus newStatus,
    required String taskId,
  }) {
    final list = _taskListData[prevStatus];
    final listWhereToPlace = _taskListData[newStatus];
    if (list != null) {
      final task = list.data.firstWhere((task) => task.id == taskId);
      TaskModel newTask = task.copyWith(status: newStatus.label);
      list.data.removeWhere((task) => task.id == taskId);
      if (listWhereToPlace != null) {
        listWhereToPlace.data.add(newTask);
      } else {
        _taskListData[newStatus] = TaskListModel(
          status: "success",
          data: [newTask],
        );
      }
    }
    update();
    refreshTaskStatusSummery();
  }

  Future<bool> removeTask(String taskId, TaskStatus status) async {
    _taskDeleteError = null;
    _isTaskDeleteLoading = true;
    update();
    NetworkResponse response = await _networkClient.getRequest(
      url: Urls.deleteTask(taskId),
      token: true,
    );

    if (response.isSuccess) {
      removeTaskOptimistically(status, taskId);
    } else {
      _taskDeleteError = response.errorMessage;
    }
    _isTaskDeleteLoading = false;
    update();
    return response.isSuccess;
  }

  Future<bool> updateTaskStatus({
    required String taskId,
    required TaskStatus prevStatus,
    required TaskStatus newStatus,
  }) async {
    _taskStatusUpdateError = null;
    _isTaskStatusUpdating = true;
    update();
    NetworkResponse response = await _networkClient.getRequest(
      url: Urls.updateTaskStatus(taskId, newStatus.label),
      token: true,
    );
    if (response.isSuccess) {
      updateTaskStatusOptimistically(
        prevStatus: prevStatus,
        newStatus: newStatus,
        taskId: taskId,
      );
    } else {
      _taskStatusUpdateError = response.errorMessage;
    }
    _isTaskStatusUpdating = false;
    update();
    return response.isSuccess;
  }

  void _setLoading(TaskStatus status, bool isLoading) {
    _loadings[status] = isLoading;
  }

  void _setError(TaskStatus status, String? error) {
    _errors[status] = error;
  }
}

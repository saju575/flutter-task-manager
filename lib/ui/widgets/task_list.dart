import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/ui/controllers/task_controller.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/delete_task.dart';

// import 'package:task_manager/ui/widgets/delete_task.dart';
import 'package:task_manager/ui/widgets/empty_placeholder.dart';
import 'package:task_manager/ui/widgets/show_app_bottom_sheet.dart';
// import 'package:task_manager/ui/widgets/show_app_bottom_sheet.dart';
import 'package:task_manager/ui/widgets/spiner.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
import 'package:task_manager/ui/widgets/update_task_status.dart';
// import 'package:task_manager/ui/widgets/update_task_status.dart';

class TaskList extends StatefulWidget {
  final TaskStatus status;
  final String? errorMessage;
  final String? emptyDataMessage;

  const TaskList({
    super.key,
    required this.status,
    this.errorMessage,
    this.emptyDataMessage,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final TaskController _taskController = Get.find<TaskController>();
  // late List<TaskModel> _taskListData = [];
  // late bool _isFetchingTaskList = false;
  // late bool _isError = false;
  // late bool _isInitialFetch = false;

  @override
  void initState() {
    super.initState();
    _taskController.initialFetchTaskList(status: widget.status);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTaskList();
  }

  Widget _buildTaskList() {
    TextTheme textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: _refreshTaskList,
      child: _buildTaskListContent(textTheme),
    );
  }

  Widget _buildTaskListContent(TextTheme textTheme) {
    return GetBuilder<TaskController>(
      builder: (controller) {
        final taskList = controller.getTaskList(widget.status);
        final isLoading = controller.getLoading(widget.status);
        final error = controller.getError(widget.status);
        if (isLoading && (taskList == null || taskList.data.isEmpty)) {
          return Center(
            child: Spinner(size: 24, color: AppColors.primaryColor),
          );
        } else if (error != null) {
          return ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: EmptyPlaceholder(
                  message: widget.errorMessage ?? "Error fetching task list",
                ),
              ),
            ],
          );
        } else if (taskList == null || taskList.data.isEmpty) {
          return ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: EmptyPlaceholder(
                    message: widget.emptyDataMessage ?? "No data found",
                  ),
                ),
              ),
            ],
          );
        } else {
          return _taskList(textTheme);
        }
      },
    );
  }

  Widget _taskList(TextTheme textTheme) {
    return GetBuilder<TaskController>(
      builder:
          (controller) => ListView.separated(
            itemBuilder:
                (context, index) => TaskCard(
                  task: controller.getTaskList(widget.status)!.data[index],
                  onDelete: () {
                    deleteTask(
                      context: context,
                      taskId:
                          controller.getTaskList(widget.status)!.data[index].id,
                      status: widget.status,
                      onSuccess: _refreshTaskList,
                    );
                  },
                  onEdit: () {
                    showAppBottomSheet(
                      context: context,
                      child: UpdateTaskStatus(
                        taskId:
                            controller
                                .getTaskList(widget.status)!
                                .data[index]
                                .id,
                        currentStatus: widget.status,
                        onSuccess: _refreshTaskList,
                      ),
                    );
                  },
                ),
            separatorBuilder: (context, index) => SizedBox(height: 9),
            itemCount: controller.getTaskList(widget.status)?.data.length ?? 0,
          ),
    );
  }

  // Future<void> _initialFetchTaskList() async {
  //   setState(() {
  //     _isError = false;
  //     _isInitialFetch = true;
  //     _isFetchingTaskList = true;
  //   });
  //   await _getTaskList();
  //   setState(() {
  //     _isFetchingTaskList = false;
  //     _isInitialFetch = false;
  //   });
  // }

  // Future<void> _getTaskList() async {
  //   NetworkResponse response = await NetworkClient.getRequest(
  //     url: Urls.getLaskListByStatus(widget.status),
  //     token: true,
  //   );
  //   if (response.isSuccess) {
  //     _taskListData = TaskListModel.fromJson(response.data).data;
  //   } else {
  //     _isError = true;
  //   }
  // }

  Future<void> _refreshTaskList() async {
    await _taskController.refreshTaskList(status: widget.status);
  }
}

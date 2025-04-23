import 'package:flutter/material.dart';
import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/task_controller.dart';
import 'package:task_manager/ui/routes/app_routes.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/delete_task.dart';
import 'package:task_manager/ui/widgets/empty_placeholder.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/spiner.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
import 'package:task_manager/ui/widgets/task_manager_status_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  late List<TaskModel> _taskListData = [];
  late bool _isFetchingTaskList = false;
  late bool _isError = false;
  late bool _isInitialFetch = false;
  @override
  void initState() {
    super.initState();
    _getTaskStatusSummery();
    _initialFetchTaskList();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
          child: RefreshIndicator(
            onRefresh: _refreshTaskList,
            child: CustomScrollView(
              scrollBehavior: ScrollBehavior().copyWith(scrollbars: false),
              slivers: [
                SliverToBoxAdapter(child: _buildSummarySection(textTheme)),
                const SliverToBoxAdapter(child: SizedBox(height: 9)),
                _newTaskList(textTheme),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddTaskButton,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _newTaskList(TextTheme textTheme) {
    if (_isInitialFetch && _isFetchingTaskList) {
      return SliverFillRemaining(
        child: Center(child: Spinner(size: 24, color: AppColors.primaryColor)),
      );
    } else if (_isError) {
      return SliverFillRemaining(
        child: Center(
          child: EmptyPlaceholder(message: "Error fetching task list"),
        ),
      );
    } else if (_taskListData.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: EmptyPlaceholder(message: "No new task found")),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => TaskCard(
            task: _taskListData[index],
            onDelete:
                () => deleteTask(
                  context: context,
                  taskId: _taskListData[index].id,
                  onSuccess: _refreshTaskList,
                ),
          ),
          childCount: _taskListData.length,
        ),
      );
    }
  }

  Widget _buildSummarySection(TextTheme textTheme) {
    return Row(
      spacing: 4,
      children: [
        TaskManagerStatusCard(
          textTheme: textTheme,
          count: TaskController.taskStatusSummery?.totalNewTasks ?? 0,
          title: "New Task",
        ),
        TaskManagerStatusCard(
          textTheme: textTheme,
          count: TaskController.taskStatusSummery?.totalCompletedTasks ?? 0,
          title: "Completed",
        ),
        TaskManagerStatusCard(
          textTheme: textTheme,
          count: TaskController.taskStatusSummery?.totalProgressTasks ?? 0,
          title: "Progress",
        ),
        TaskManagerStatusCard(
          textTheme: textTheme,
          count: TaskController.taskStatusSummery?.totalCancelledTasks ?? 0,
          title: "Cancelled",
        ),
      ],
    );
  }

  void _onTapAddTaskButton() {
    Navigator.pushNamed(context, AppRoutes.addNewTask);
  }

  Future<void> _getTaskStatusSummery() async {
    await TaskController.getTaskStatusSummery();
    setState(() {});
  }

  Future<void> _initialFetchTaskList() async {
    setState(() {
      _isError = false;
      _isInitialFetch = true;
      _isFetchingTaskList = true;
    });
    await _getTaskList();
    setState(() {
      _isFetchingTaskList = false;
      _isInitialFetch = false;
    });
  }

  Future<void> _getTaskList() async {
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.getLaskListByStatus(TaskStatus.newTask.label),
      token: true,
    );
    if (response.isSuccess) {
      _taskListData = TaskListModel.fromJson(response.data).data;
    } else {
      _isError = true;
    }
  }

  Future<void> _refreshTaskList() async {
    setState(() {
      _isError = false;
    });
    await Future.wait([_getTaskList(), _getTaskStatusSummery()]);
  }
}

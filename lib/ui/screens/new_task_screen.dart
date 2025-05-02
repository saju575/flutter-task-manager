import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/enums/task_status.dart';

import 'package:task_manager/ui/controllers/task_controller.dart';
import 'package:task_manager/ui/routes/app_routes.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/delete_task.dart';

import 'package:task_manager/ui/widgets/empty_placeholder.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/show_app_bottom_sheet.dart';

import 'package:task_manager/ui/widgets/spiner.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
import 'package:task_manager/ui/widgets/task_manager_status_card.dart';
import 'package:task_manager/ui/widgets/update_task_status.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final TaskController _taskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    _taskController.getInitialTaskStatusSummery();
    _taskController.initialFetchTaskList(status: TaskStatus.newTask);
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
    return GetBuilder<TaskController>(
      builder: (controller) {
        final taskList = controller.getTaskList(TaskStatus.newTask);
        final isLoading = controller.getLoading(TaskStatus.newTask);
        final error = controller.getError(TaskStatus.newTask);
        if (isLoading && (taskList == null || taskList.data.isEmpty)) {
          return SliverFillRemaining(
            child: Center(
              child: Spinner(size: 24, color: AppColors.primaryColor),
            ),
          );
        } else if (error != null) {
          return SliverFillRemaining(
            child: Center(
              child: EmptyPlaceholder(message: "Error fetching task list"),
            ),
          );
        } else if (taskList == null || taskList.data.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: EmptyPlaceholder(message: "No new task found"),
            ),
          );
        } else {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => TaskCard(
                task: controller.getTaskList(TaskStatus.newTask)!.data[index],
                onDelete:
                    () => deleteTask(
                      context: context,
                      taskId:
                          controller
                              .getTaskList(TaskStatus.newTask)!
                              .data[index]
                              .id,
                      status: TaskStatus.newTask,
                    ),
                onEdit: () {
                  showAppBottomSheet(
                    context: context,
                    child: UpdateTaskStatus(
                      taskId:
                          controller
                              .getTaskList(TaskStatus.newTask)!
                              .data[index]
                              .id,
                      currentStatus: TaskStatus.newTask,
                    ),
                  );
                },
              ),
              childCount:
                  controller.getTaskList(TaskStatus.newTask)?.data.length ?? 0,
            ),
          );
        }
      },
    );
  }

  Widget _buildSummarySection(TextTheme textTheme) {
    return GetBuilder<TaskController>(
      builder:
          (controller) => Row(
            spacing: 4,
            children: [
              TaskManagerStatusCard(
                textTheme: textTheme,
                count: controller.taskStatusSummery?.totalNewTasks ?? 0,
                title: "New Task",
              ),
              TaskManagerStatusCard(
                textTheme: textTheme,
                count: controller.taskStatusSummery?.totalCompletedTasks ?? 0,
                title: "Completed",
              ),
              TaskManagerStatusCard(
                textTheme: textTheme,
                count: controller.taskStatusSummery?.totalProgressTasks ?? 0,
                title: "Progress",
              ),
              TaskManagerStatusCard(
                textTheme: textTheme,
                count: controller.taskStatusSummery?.totalCancelledTasks ?? 0,
                title: "Cancelled",
              ),
            ],
          ),
    );
  }

  void _onTapAddTaskButton() {
    Navigator.pushNamed(context, AppRoutes.addNewTask);
  }

  Future<void> _refreshTaskList() async {
    await Future.wait([
      _taskController.refreshTaskList(status: TaskStatus.newTask),
      _taskController.refreshTaskStatusSummery(),
    ]);
  }
}

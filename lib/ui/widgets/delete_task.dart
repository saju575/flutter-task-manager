import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/ui/controllers/task_controller.dart';
import 'package:task_manager/ui/widgets/alert_message.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

Future<void> deleteTask({
  required BuildContext context,
  required String taskId,
  required TaskStatus status,
  Function? onSuccess,
  Function? onError,
}) async {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final TaskController taskController = Get.find<TaskController>();
  await showAlert(
    context: context,
    title: "Delete Task",
    message: "Are you sure you want to delete this task?",
    cancelText: "No",
    confirmText: "Yes",
    isLoading: isLoading,
    onConfirm: () async {
      isLoading.value = true;

      final response = await taskController.removeTask(taskId, status);

      isLoading.value = false;

      if (response) {
        if (context.mounted) {
          Navigator.of(context).pop();
          showSnackBarMessage(context, message: "Task Deleted Successfully");
        }
        await onSuccess?.call();
      } else {
        await onError?.call();
        if (context.mounted) {
          showSnackBarMessage(
            context,
            isError: true,
            message: taskController.taskDeleteError!,
          );
        }
      }
    },
  );
}

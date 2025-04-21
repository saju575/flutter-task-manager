import 'package:flutter/widgets.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/alert_message.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

// Future<void> deleteTask({
//   required BuildContext context,
//   required String taskId,
//   Function? onSuccess,
//   Function? onError,
// }) async {
//   showAlert(
//     context: context,
//     title: "Delete Task",
//     message: "Are you sure you want to delete this task?",
//     cancelText: "No",
//     confirmText: "Yes",
//     onConfirm: () async {
//       NetworkResponse response = await NetworkClient.getRequest(
//         url: Urls.deleteTask(taskId),
//         token: true,
//       );
//       if (response.isSuccess) {
//         await onSuccess?.call();
//         if (context.mounted) {
//           showSnackBarMessage(context, message: "Task Deleted Successfully");
//         }
//       } else {
//         await onError?.call();
//         if (context.mounted) {
//           showSnackBarMessage(
//             context,
//             isError: true,
//             message: response.errorMessage,
//           );
//         }
//       }
//     },
//   );
// }

Future<void> deleteTask({
  required BuildContext context,
  required String taskId,
  Function? onSuccess,
  Function? onError,
}) async {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  await showAlert(
    context: context,
    title: "Delete Task",
    message: "Are you sure you want to delete this task?",
    cancelText: "No",
    confirmText: "Yes",
    isLoading: isLoading,
    onConfirm: () async {
      isLoading.value = true;

      NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.deleteTask(taskId),
        token: true,
      );

      isLoading.value = false;

      if (response.isSuccess) {
        if (context.mounted) {
          Navigator.of(context).pop(); // ✅ close dialog
          showSnackBarMessage(context, message: "Task Deleted Successfully");
        }
        await onSuccess?.call();
      } else {
        await onError?.call();
        if (context.mounted) {
          showSnackBarMessage(
            context,
            isError: true,
            message: response.errorMessage,
          );
        }
      }
    },
  );
}

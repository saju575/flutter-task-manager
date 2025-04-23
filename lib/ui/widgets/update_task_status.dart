import 'package:flutter/material.dart';
import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/spiner.dart';

class UpdateTaskStatus extends StatefulWidget {
  final String taskId;
  final TaskStatus currentStatus;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  const UpdateTaskStatus({
    super.key,
    required this.taskId,
    required this.currentStatus,
    this.onSuccess,
    this.onError,
  });

  @override
  State<UpdateTaskStatus> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTaskStatus> {
  late TaskStatus selectedStatus;
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Update Task Status",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children:
                TaskStatus.values.map((status) {
                  return ListTileTheme(
                    contentPadding:
                        EdgeInsets.zero, // Removes default horizontal padding
                    child: RadioListTile<TaskStatus>(
                      value: status,
                      groupValue: selectedStatus,
                      onChanged:
                          (value) => setState(() => selectedStatus = value!),
                      title: Text(_getStatusLabel(status)),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _isLoading
                      ? null
                      : () => _submitStatusUpdate(
                        context,
                        widget.taskId,
                        selectedStatus,
                        onSuccess: widget.onSuccess,
                        onError: widget.onError,
                      ),
              child:
                  _isLoading
                      ? const Spinner(size: 12)
                      : const Text("Save Changes"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitStatusUpdate(
    BuildContext context,
    String taskId,
    TaskStatus status, {
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    setState(() => _isLoading = true);
    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.updateTaskStatus(taskId, status.label),
      token: true,
    );
    setState(() {
      _isLoading = false;
    });
    if (response.isSuccess) {
      if (context.mounted) {
        Navigator.of(context).pop();
        showSnackBarMessage(context, message: "Status Updated Successfully");
        onSuccess?.call();
      }
    } else {
      if (context.mounted) {
        showSnackBarMessage(
          context,
          isError: true,
          message: response.errorMessage,
        );
        onError?.call();
      }
    }
  }

  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.newTask:
        return "New";
      case TaskStatus.progress:
        return "In Progress";
      case TaskStatus.completed:
        return "Completed";
      case TaskStatus.canceled:
        return "Canceled";
    }
  }
}

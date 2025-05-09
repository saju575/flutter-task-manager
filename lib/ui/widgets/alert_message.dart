import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/spiner.dart';

Future<void> showAlert({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'OK',
  String? cancelText = "No",
  Future<void> Function()? onConfirm,
  VoidCallback? onCancel,
  ValueNotifier<bool>? isLoading,
  bool isDismissible = true,
}) {
  final ValueNotifier<bool> loading = isLoading ?? ValueNotifier(false);
  return showDialog(
    context: context,
    barrierDismissible: isDismissible,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (cancelText != null)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onCancel != null) onCancel();
                  },
                  child: Text(
                    cancelText,
                    style: const TextStyle(color: AppColors.textColor),
                  ),
                ),
              SizedBox(width: 8),
              ValueListenableBuilder<bool>(
                valueListenable: loading,
                builder: (context, loading, _) {
                  return ElevatedButton(
                    onPressed: loading ? null : onConfirm,
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromWidth(double.nan),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child:
                        loading ? const Spinner(size: 12) : Text(confirmText),
                  );
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

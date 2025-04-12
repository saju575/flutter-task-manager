import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

Future<void> showAlert({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'OK',
  String? cancelText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool isDismissible = true,
}) {
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
              ElevatedButton(
                onPressed: onConfirm,
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
                child: Text(confirmText),
              ),
            ],
          ),
        ],
      );
    },
  );
}

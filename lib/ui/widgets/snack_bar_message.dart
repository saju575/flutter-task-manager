import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

void showSnackBarMessage(
  BuildContext context, {
  String message = '',
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        textAlign: TextAlign.center,
        message,
        style: const TextStyle(color: AppColors.whiteColor),
      ),
      backgroundColor: isError ? Colors.red : null,
    ),
  );
}

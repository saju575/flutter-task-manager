import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

void showSnackBarMessage(
  BuildContext context, {
  String message = '',
  bool isError = false,
}) {
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     content: Text(
  //       textAlign: TextAlign.center,
  //       message,
  //       style: const TextStyle(color: AppColors.whiteColor),
  //     ),
  //     backgroundColor: isError ? Colors.red : null,
  //   ),
  // );
  Get.snackbar(
    '', // Ignored because we're using titleText/messageText
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: isError ? Colors.red : AppColors.primaryColor,
    snackStyle: SnackStyle.FLOATING,
    colorText: AppColors.whiteColor,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
    padding: const EdgeInsets.only(top: 0, bottom: 5),
    borderRadius: 4,
    duration: const Duration(seconds: 2),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    titleText: const SizedBox.shrink(),
    messageText: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.whiteColor, fontSize: 14),
    ),
  );
}

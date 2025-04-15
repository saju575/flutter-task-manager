import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/utils/app_icons.dart';
import 'package:task_manager/ui/widgets/app_icon.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({
    super.key,
    this.iconName,
    this.iconColor,
    this.message,
    this.gap,
  });
  final String? iconName;
  final Color? iconColor;
  final double iconSize = 150;
  final String? message;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIcon(
          iconName: iconName ?? AppIcons.notFound,
          size: iconSize,
          color: iconColor ?? AppColors.primaryColor,
        ),
        SizedBox(height: gap ?? 20),
        Text(
          message ?? "No data found",
          style: const TextStyle(color: AppColors.textColor),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TaskManagerStatusCard extends StatelessWidget {
  const TaskManagerStatusCard({
    super.key,
    required this.textTheme,
    required this.title,
    required this.count,
  });

  final TextTheme textTheme;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: AppColors.whiteColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                count.toString(),
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                title,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 8,
                  color: AppColors.grayColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

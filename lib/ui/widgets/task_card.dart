import 'package:flutter/material.dart';
import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      color: AppColors.whiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryColor,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 4),
            Text(
              task.description,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 8,
                color: AppColors.textColor,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 8),
            Text(
              "Data: ${task.createdDate}",
              style: textTheme.bodySmall?.copyWith(
                fontSize: 8,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 14,
                    right: 14,
                    top: 2,
                    bottom: 4, // Controls horizontal spacing
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(50), // Keeps it rounded
                  ),
                  child: Center(
                    child: Text(
                      task.status,
                      style: TextStyle(
                        fontSize: 10, // Adjust text size
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit_note_sharp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete, color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color get statusBgColor {
    if (task.status == TaskStatus.newTask.label) {
      return AppColors.primaryColor;
    } else if (task.status == TaskStatus.progress.label) {
      return AppColors.purpleColor;
    } else if (task.status == TaskStatus.completed.label) {
      return AppColors.primaryColor;
    } else {
      return AppColors.dengerColor;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.textTheme,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.statusBgColor,
  });

  final TextTheme textTheme;
  final String title;
  final String description;
  final String date;
  final String status;
  final Color statusBgColor;

  @override
  Widget build(BuildContext context) {
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
              title,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryColor,
              ),
              maxLines: 1,
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 8,
                color: AppColors.textColor,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 8),
            Text(
              "Data: $date",
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
                      status,
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
}

import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TaskManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({
    super.key,
    required this.textTheme,
    required this.name,
    required this.gmail,
    this.onLogout,
  });

  final TextTheme textTheme;
  final String name;
  final String gmail;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 2),
                Text(
                  gmail,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onLogout,
            icon: Icon(
              Icons.login_outlined,
              color: Colors.red.shade400,
              size: 24,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.primaryColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

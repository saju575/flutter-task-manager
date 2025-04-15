import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/routes/app_routes.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/alert_message.dart';

class TaskManagerAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  State<TaskManagerAppBar> createState() => TaskManagerAppBarState();
}

class TaskManagerAppBarState extends State<TaskManagerAppBar> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.whiteColor),
      actionsPadding: EdgeInsets.only(right: 16),
      title: GestureDetector(
        onTap: () => _onTapProfile(context),
        child: Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  _shouldShowImage(AuthController.userModel?.photo)
                      ? MemoryImage(
                        base64Decode(AuthController.userModel?.photo ?? ""),
                      )
                      : null,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AuthController.userModel?.fullName ?? "",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 2),
                Text(
                  AuthController.userModel?.email ?? "",
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),

      backgroundColor: AppColors.primaryColor,
      actions: [
        IconButton(
          onPressed:
              () => showAlert(
                context: context,
                title: "Are you sure?",
                message: "Are you sure you want to logout?",
                confirmText: "Logout",
                cancelText: "No",
                onConfirm: () => _onTapLogout(context),
              ),
          icon: Icon(
            Icons.logout_outlined,
            color: Colors.red.shade400,
            size: 24,
          ),
        ),
      ],
    );
  }

  void _onTapProfile(BuildContext context) {
    if (ModalRoute.of(context)?.settings.name != AppRoutes.updateProfile) {
      Navigator.pushNamed(context, AppRoutes.updateProfile);
    }
  }

  Future<void> _onTapLogout(BuildContext context) async {
    await AuthController.clearUserData();

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (predicate) => false,
      );
    }
  }

  bool _shouldShowImage(String? photo) {
    return photo != null && photo.isNotEmpty;
  }
}

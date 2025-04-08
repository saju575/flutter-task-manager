import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/routes/app_routes.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class TaskManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({super.key, required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: Navigator.canPop(context) ? 0 : 14,
      iconTheme: IconThemeData(color: AppColors.whiteColor),
      title: GestureDetector(
        onTap: () => _onTapProfile(context),
        child: Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(radius: 16),

            Expanded(
              child: Column(
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
            ),
            IconButton(
              onPressed: () => _onTapLogout(context),
              icon: Icon(
                Icons.login_outlined,
                color: Colors.red.shade400,
                size: 24,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.primaryColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);

  void _onTapProfile(BuildContext context) {
    if (ModalRoute.of(context)?.settings.name != AppRoutes.updateProfile) {
      Navigator.pushNamed(context, AppRoutes.updateProfile);
    }
  }

  Future<void> _onTapLogout(BuildContext context) async {
    await AuthController.clearUserData();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (predicate) => false,
      );
    }
  }
}

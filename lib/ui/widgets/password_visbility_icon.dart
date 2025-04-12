import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class PasswordVisbilityIcon extends StatelessWidget {
  final bool isPasswordHidden;
  final VoidCallback onTapPasswordHide;

  const PasswordVisbilityIcon({
    super.key,
    required this.isPasswordHidden,
    required this.onTapPasswordHide,
  });
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTapPasswordHide,
      icon: Icon(
        isPasswordHidden ? Icons.visibility : Icons.visibility_off,
        color: AppColors.textColor,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

class Spinner extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? strokeWidth;

  const Spinner({
    super.key,
    this.size = 16,
    this.color = AppColors.whiteColor,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(color: color, strokeWidth: strokeWidth),
    );
  }
}

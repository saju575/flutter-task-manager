import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/app_bottom_sheet.dart';

void showAppBottomSheet({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (_) => AppBottomSheet(child: child),
  );
}

import 'package:flutter/material.dart';
import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/task_list.dart';

class CanceledScreen extends StatefulWidget {
  const CanceledScreen({super.key});

  @override
  State<CanceledScreen> createState() => _CanceledScreenState();
}

class _CanceledScreenState extends State<CanceledScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        child: TaskList(
          status: TaskStatus.canceled.label,
          emptyDataMessage: "No canceled tasks found",
        ),
      ),
    );
  }
}

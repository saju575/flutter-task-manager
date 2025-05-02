import 'package:flutter/material.dart';
import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/task_list.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        child: TaskList(
          status: TaskStatus.progress,
          emptyDataMessage: "No progress tasks found",
        ),
      ),
    );
  }
}

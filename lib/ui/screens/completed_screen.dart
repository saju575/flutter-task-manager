import 'package:flutter/material.dart';
import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/task_list.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  Widget build(BuildContext context) {
    // TextTheme textTheme = Theme.of(context).textTheme;
    return ScreenBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        child: TaskList(
          status: TaskStatus.completed,
          emptyDataMessage: "No completed tasks found",
        ),
      ),
    );
  }
}

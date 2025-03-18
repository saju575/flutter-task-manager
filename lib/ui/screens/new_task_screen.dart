import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/task_manager_status_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
          child: Column(children: [_buildSummarySection(textTheme)]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection(TextTheme textTheme) {
    return Row(
      spacing: 4,
      children: [
        TaskManagerStatusCard(
          textTheme: textTheme,
          count: 3,
          title: "New Task",
        ),
        TaskManagerStatusCard(
          textTheme: textTheme,
          count: 3,
          title: "Completed",
        ),
        TaskManagerStatusCard(
          textTheme: textTheme,
          count: 6,
          title: "Progress",
        ),
        TaskManagerStatusCard(
          textTheme: textTheme,
          count: 9,
          title: "Cancelled",
        ),
      ],
    );
  }
}

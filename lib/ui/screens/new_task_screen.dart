import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/task_card.dart';
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
          child: CustomScrollView(
            scrollBehavior: ScrollBehavior().copyWith(scrollbars: false),
            slivers: [
              SliverToBoxAdapter(child: _buildSummarySection(textTheme)),
              const SliverToBoxAdapter(child: SizedBox(height: 9)),
              _newTaskList(textTheme),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _newTaskList(TextTheme textTheme) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => TaskCard(
          textTheme: textTheme,
          title: "Task Title",
          description: "Description",
          date: "01/01/2023",
          status: "New",
          statusBgColor: AppColors.primaryColor,
        ),
        childCount: 10,
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

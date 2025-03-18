import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      itemBuilder:
          (context, index) => TaskCard(
            textTheme: textTheme,
            title: "Task Title",
            description: "Description",
            date: "01/01/2023",
            status: "Progress",
            statusBgColor: AppColors.purpleColor,
          ),
      separatorBuilder: (context, index) => SizedBox(height: 9),
      itemCount: 10,
    );
  }
}

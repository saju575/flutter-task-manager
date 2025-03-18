import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CancelledScreen extends StatefulWidget {
  const CancelledScreen({super.key});

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
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
            status: "Cancelled",
            statusBgColor: AppColors.dengerColor,
          ),
      separatorBuilder: (context, index) => SizedBox(height: 9),
      itemCount: 10,
    );
  }
}

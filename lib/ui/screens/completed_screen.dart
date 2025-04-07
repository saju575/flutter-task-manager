import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ScreenBackground(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemBuilder:
              (context, index) => TaskCard(
                textTheme: textTheme,
                title: "Task Title",
                description: "Description",
                date: "01/01/2023",
                status: "Completed",
                statusBgColor: AppColors.primaryColor,
              ),
          separatorBuilder: (context, index) => SizedBox(height: 9),
          itemCount: 10,
        ),
      ),
    );
  }
}

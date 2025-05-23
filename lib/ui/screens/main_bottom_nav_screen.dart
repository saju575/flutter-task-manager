import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/canceled_screen.dart';
import 'package:task_manager/ui/screens/completed_screen.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/progress_screen.dart';
import 'package:task_manager/ui/widgets/task_manager_app_bar.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  List<Widget> screens = const [
    NewTaskScreen(),
    ProgressScreen(),
    CompletedScreen(),
    CanceledScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      appBar: const TaskManagerAppBar(),

      bottomNavigationBar: NavigationBar(
        height: 58,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.new_label), label: 'New Task'),
          NavigationDestination(
            icon: Icon(Icons.ac_unit_outlined),
            label: 'Progress',
          ),
          NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            label: 'Canceled',
          ),
        ],
      ),
    );
  }
}

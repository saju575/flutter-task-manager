import 'package:flutter/widgets.dart';
import 'package:task_manager/data/services/shared_prefs.dart';
import 'package:task_manager/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  runApp(const TaskManagerApp());
}

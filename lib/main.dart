import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/services/shared_prefs.dart';
import 'package:task_manager/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<SharedPrefs>(() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefs(prefs);
  });
  runApp(const TaskManagerApp());
}

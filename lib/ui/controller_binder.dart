import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/login_controller.dart';
import 'package:task_manager/ui/controllers/register_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => RegisterController());
  }
}

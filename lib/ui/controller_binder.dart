import 'package:get/get.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/services/shared_prefs.dart';
import 'package:task_manager/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/controllers/forget_password_controller.dart';
import 'package:task_manager/ui/controllers/login_controller.dart';
import 'package:task_manager/ui/controllers/register_controller.dart';
import 'package:task_manager/ui/controllers/task_controller.dart';
import 'package:task_manager/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() async {
    // Get.lazyPut(() async {
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   return SharedPrefs(prefs);
    // });

    // Get.putAsync<SharedPrefs>(() async {
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   return SharedPrefs(prefs);
    // });

    Get.lazyPut(() => AuthController(Get.find<SharedPrefs>()));
    Get.lazyPut(
      () => NetworkClient(authController: Get.find<AuthController>()),
    );
    Get.lazyPut(
      () => LoginController(
        authController: Get.find<AuthController>(),
        networkClient: Get.find<NetworkClient>(),
      ),
    );
    Get.lazyPut(
      () => RegisterController(networkClient: Get.find<NetworkClient>()),
    );
    Get.lazyPut(
      () => ForgetPasswordController(networkClient: Get.find<NetworkClient>()),
    );
    Get.lazyPut(
      () => UpdateProfileController(
        networkClient: Get.find<NetworkClient>(),
        authController: Get.find<AuthController>(),
      ),
    );
    Get.lazyPut(
      () => AddNewTaskController(
        networkClient: Get.find<NetworkClient>(),
        taskController: Get.find<TaskController>(),
      ),
    );

    Get.lazyPut(() => TaskController(networkClient: Get.find<NetworkClient>()));
  }
}

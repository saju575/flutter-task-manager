import 'package:get/state_manager.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';

class LoginController extends GetxController {
  final NetworkClient _networkClient;
  final AuthController _authController;

  LoginController({
    required NetworkClient networkClient,
    required AuthController authController,
  }) : _authController = authController,
       _networkClient = networkClient;

  late bool _isLoginInProgress = false;
  String? _errorMessage;
  late bool _isPasswordHidden = true;

  bool get isLoginInProgress => _isLoginInProgress;
  String? get errorMessage => _errorMessage;
  bool get isPasswordHidden => _isPasswordHidden;

  Future<bool> signIn({required String email, required String password}) async {
    bool isSuccess = false;
    _isLoginInProgress = true;
    update();
    Map<String, dynamic> requestBody = {"email": email, "password": password};
    NetworkResponse response = await _networkClient.postRequest(
      url: Urls.login,
      body: requestBody,
    );

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.data);

      await _authController.saveUserInformation(
        loginModel.token,
        loginModel.userData!,
      );

      isSuccess = true;
      _errorMessage = null;
    } else {
      isSuccess = false;
      _errorMessage = response.errorMessage;
    }
    _isLoginInProgress = false;
    update();
    return isSuccess;
  }

  void togglePasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    update();
  }
}

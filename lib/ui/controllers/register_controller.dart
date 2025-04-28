import 'package:get/get.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';

class RegisterController extends GetxController {
  late bool _isPasswordHidden = true;
  late bool _registrationInProgress = false;
  String? _errorMessage;

  bool get isPasswordHidden => _isPasswordHidden;
  bool get registrationInProgress => _registrationInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> register({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String password,
  }) async {
    _registrationInProgress = true;
    _errorMessage = null;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.register,
      body: requestBody,
    );
    if (!response.isSuccess) {
      _errorMessage = response.errorMessage;
    }
    _registrationInProgress = false;
    update();
    return response.isSuccess;
  }

  void togglePasswordVisibility() {
    _isPasswordHidden = !_isPasswordHidden;
    update();
  }
}

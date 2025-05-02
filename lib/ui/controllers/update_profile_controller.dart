import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';

class UpdateProfileController extends GetxController {
  final NetworkClient _networkClient;
  final AuthController _authController;

  UpdateProfileController({
    required NetworkClient networkClient,
    required AuthController authController,
  }) : _networkClient = networkClient,
       _authController = authController;

  bool _isUpdatingProfile = false;
  bool _isPasswordHidden = true;
  String? _errorMessageOfProfileUpdate;
  XFile? _pickedImage;

  bool get isUpdatingProfile => _isUpdatingProfile;
  bool get isPasswordHidden => _isPasswordHidden;
  String? get errorMessageOfProfileUpdate => _errorMessageOfProfileUpdate;
  XFile? get pickedImage => _pickedImage;

  set pickedImage(XFile? value) {
    _pickedImage = value;
    update();
  }

  set isPasswordHidden(bool value) {
    _isPasswordHidden = value;
    update();
  }

  UserModel? get userData => _authController.userModel;

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String mobile,
    String? password,
    XFile? image,
  }) async {
    _errorMessageOfProfileUpdate = null;
    _isUpdatingProfile = true;
    update();

    Map<String, dynamic> requestBody = {
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password != null && password.isNotEmpty) {
      requestBody["password"] = password;
    }
    if (image != null) {
      List<int> imageByte = await image.readAsBytes();
      requestBody["photo"] = base64Encode(imageByte);
    }

    NetworkResponse response = await _networkClient.postRequest(
      url: Urls.updateProfile,
      token: true,
      body: requestBody,
    );
    if (response.isSuccess) {
      await _authController.setUserInformation(newUser: requestBody);
    } else {
      _errorMessageOfProfileUpdate = response.errorMessage;
    }
    _isUpdatingProfile = false;
    update();
    return response.isSuccess;
  }
}

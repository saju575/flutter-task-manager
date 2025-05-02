import 'package:get/get.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';

class ForgetPasswordController extends GetxController {
  final NetworkClient _networkClient;

  ForgetPasswordController({required NetworkClient networkClient})
    : _networkClient = networkClient;

  late bool _isEmailVerifierLoading = false;
  late bool _isPinVerifierLoading = false;
  late bool _hasErrorOnPinVerification = false;
  late bool _isLoadingResetPassword = false;
  late bool _isPasswordHidden = true;
  late bool _isConfirmPasswordHidden = true;
  late String? _errorMessageOfEmailVerifier;
  late String? _errorMessageOfPinVerifier;
  late String? _errorMessageOfResetPassword;

  bool get isEmailVerifierLoading => _isEmailVerifierLoading;
  bool get isPinVerifierLoading => _isPinVerifierLoading;
  bool get hasErrorOnPinVerification => _hasErrorOnPinVerification;
  bool get isLoadingResetPassword => _isLoadingResetPassword;
  bool get isPasswordHidden => _isPasswordHidden;
  bool get isConfirmPasswordHidden => _isConfirmPasswordHidden;
  String? get errorMessageOfEmailVerifier => _errorMessageOfEmailVerifier;
  String? get errorMessageOfPinVerifier => _errorMessageOfPinVerifier;
  String? get errorMessageOfResetPassword => _errorMessageOfResetPassword;

  set hasErrorOnPinVerification(bool value) {
    _hasErrorOnPinVerification = value;
    update();
  }

  set isPasswordHidden(bool value) {
    _isPasswordHidden = value;
    update();
  }

  set isConfirmPasswordHidden(bool value) {
    _isConfirmPasswordHidden = value;
    update();
  }

  Future<bool> recoverVerifyEmail({required String email}) async {
    _errorMessageOfEmailVerifier = null;
    _isEmailVerifierLoading = true;
    update();
    NetworkResponse response = await _networkClient.getRequest(
      url: Urls.recoverVerifyEmail(email),
    );
    if (!response.isSuccess) {
      _errorMessageOfEmailVerifier = response.errorMessage;
    }
    _isEmailVerifierLoading = false;
    update();
    return response.isSuccess;
  }

  Future<bool> recoverVerifyPin({
    required String pin,
    required String email,
  }) async {
    _errorMessageOfPinVerifier = null;
    _isPinVerifierLoading = true;
    update();
    NetworkResponse response = await _networkClient.getRequest(
      url: Urls.recoverVerifyOtp(email, pin),
    );
    if (!response.isSuccess) {
      _errorMessageOfPinVerifier = response.errorMessage;
    }
    _isPinVerifierLoading = false;
    update();
    return response.isSuccess;
  }

  Future<bool> resetPassword({
    required String pin,
    required String email,
    required String password,
  }) async {
    _errorMessageOfResetPassword = null;
    _isLoadingResetPassword = true;
    update();
    NetworkResponse response = await _networkClient.postRequest(
      url: Urls.resetRecoverPassword,
      body: {"email": email, "OTP": pin, "password": password},
    );
    if (!response.isSuccess) {
      _errorMessageOfResetPassword = response.errorMessage;
    }
    _isLoadingResetPassword = false;
    update();
    return response.isSuccess;
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/forget_password_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/utils/input_validator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/spiner.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _confirmPasswordTExtController =
      TextEditingController();
  final TextEditingController _passwordTExtController = TextEditingController();
  final ForgetPasswordController _forgetPasswordController =
      Get.find<ForgetPasswordController>();

  @override
  void dispose() {
    _confirmPasswordTExtController.dispose();
    _passwordTExtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Set Password",
                      style: TextTheme.of(context).titleLarge,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      "Minimum length password 8 character with Latter and number combination",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),

                    GetBuilder<ForgetPasswordController>(
                      builder:
                          (controller) => TextFormField(
                            textInputAction: TextInputAction.next,
                            obscureText: controller.isPasswordHidden,
                            validator: InputValidator.validatePassword,
                            controller: _passwordTExtController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefix: Padding(
                                padding: EdgeInsets.only(left: 16),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.isPasswordHidden =
                                      !controller.isPasswordHidden;
                                },
                                icon: Icon(
                                  controller.isPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                          ),
                    ),

                    const SizedBox(height: 12),

                    GetBuilder<ForgetPasswordController>(
                      builder:
                          (controller) => TextFormField(
                            controller: _confirmPasswordTExtController,
                            validator:
                                (String? value) =>
                                    InputValidator.validateConfirmPassword(
                                      value,
                                      _passwordTExtController.text,
                                    ),
                            obscureText: controller.isConfirmPasswordHidden,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              prefix: Padding(
                                padding: EdgeInsets.only(left: 16),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.isConfirmPasswordHidden =
                                      !controller.isConfirmPasswordHidden;
                                },
                                icon: Icon(
                                  controller.isConfirmPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ),
                          ),
                    ),

                    const SizedBox(height: 18),

                    GetBuilder<ForgetPasswordController>(
                      builder:
                          (controller) => ElevatedButton(
                            onPressed:
                                controller.isLoadingResetPassword
                                    ? null
                                    : _onTapSubmitButton,
                            child:
                                controller.isLoadingResetPassword
                                    ? const Spinner()
                                    : const Text("Confirm"),
                          ),
                    ),

                    const SizedBox(height: 44),

                    Center(
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextTheme.of(context).bodySmall?.copyWith(
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(text: "Have account? "),
                                TextSpan(
                                  text: 'Sign in',
                                  style: TextTheme.of(
                                    context,
                                  ).bodySmall?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = _onTapSignIn,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _onSubmitPassword();
    }
    return;
  }

  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _onSubmitPassword() async {
    late Map<String, String> argumentData =
        ModalRoute.of(context)?.settings.arguments! as Map<String, String>;

    final response = await _forgetPasswordController.resetPassword(
      email: argumentData["email"]!,
      pin: argumentData["code"]!,
      password: _passwordTExtController.text,
    );

    if (!mounted) return;

    response
        ? Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        )
        : showSnackBarMessage(
          context,
          message: _forgetPasswordController.errorMessageOfResetPassword!,
        );
  }
}

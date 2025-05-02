import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/forget_password_controller.dart';
import 'package:task_manager/ui/routes/app_routes.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/utils/input_validator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/spiner.dart';

class ForgetPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgetPasswordVerifyEmailScreen({super.key});

  @override
  State<ForgetPasswordVerifyEmailScreen> createState() =>
      _ForgetPasswordVerifyEmailScreenState();
}

class _ForgetPasswordVerifyEmailScreenState
    extends State<ForgetPasswordVerifyEmailScreen> {
  final TextEditingController _emailTExtController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ForgetPasswordController _forgetPasswordController =
      Get.find<ForgetPasswordController>();

  @override
  void dispose() {
    _emailTExtController.dispose();
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
                      "Your Email Address",
                      style: TextTheme.of(context).titleLarge,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      "A 6 digit verification pin will send to your email address",
                      style: TextTheme.of(context).bodyMedium,
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTExtController,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: InputValidator.validateEmail,
                    ),

                    const SizedBox(height: 19),

                    GetBuilder<ForgetPasswordController>(
                      builder:
                          (controller) => ElevatedButton(
                            onPressed:
                                controller.isEmailVerifierLoading
                                    ? null
                                    : () => _onTapSubmitButton(context),
                            child:
                                controller.isEmailVerifierLoading
                                    ? const Spinner()
                                    : const Icon(Icons.arrow_forward),
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

  void _onTapSubmitButton(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _submitEmail(context);
    }
  }

  Future<void> _submitEmail(BuildContext context) async {
    final response = await _forgetPasswordController.recoverVerifyEmail(
      email: _emailTExtController.text.trim(),
    );

    if (!context.mounted) return;

    response
        ? Navigator.pushNamed(
          context,
          AppRoutes.forgetPasswordPinVerification,
          arguments: _emailTExtController.text.trim(),
        )
        : showSnackBarMessage(
          context,
          isError: true,
          message: _forgetPasswordController.errorMessageOfEmailVerifier!,
        );
  }

  void _onTapSignIn() {
    Navigator.pop(context);
  }
}

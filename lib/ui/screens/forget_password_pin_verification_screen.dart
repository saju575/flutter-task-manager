import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/controllers/forget_password_controller.dart';
import 'package:task_manager/ui/routes/app_routes.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/spiner.dart';
import 'package:get/get.dart';

class ForgetPasswordPinVerificationScreen extends StatefulWidget {
  const ForgetPasswordPinVerificationScreen({super.key});

  @override
  State<ForgetPasswordPinVerificationScreen> createState() =>
      _ForgetPasswordPinVerificationScreenState();
}

class _ForgetPasswordPinVerificationScreenState
    extends State<ForgetPasswordPinVerificationScreen> {
  final TextEditingController _pinCodeTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StreamController<ErrorAnimationType> _errorController =
      StreamController<ErrorAnimationType>();
  final ForgetPasswordController _forgetPasswordController =
      Get.find<ForgetPasswordController>();

  @override
  void dispose() {
    // if (mounted) {
    // _pinCodeTEController.dispose();
    // }
    _errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)?.settings.arguments as String;
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
                      "PIN Verification",
                      style: TextTheme.of(context).titleLarge,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      "Put the 6 digit pin sent to your email address",
                      style: TextTheme.of(context).bodyMedium,
                    ),

                    const SizedBox(height: 18),
                    GetBuilder<ForgetPasswordController>(
                      builder:
                          (controller) => PinCodeTextField(
                            length: 6,
                            errorAnimationController: _errorController,
                            cursorColor: AppColors.primaryColor,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(4),
                              fieldHeight: 40,
                              fieldWidth: 40,
                              activeFillColor: AppColors.whiteColor,
                              selectedFillColor: AppColors.whiteColor,
                              inactiveFillColor: AppColors.whiteColor,
                              borderWidth: 0,
                              activeColor:
                                  controller.hasErrorOnPinVerification
                                      ? AppColors.dengerColor
                                      : Colors.transparent,
                              selectedColor:
                                  controller.hasErrorOnPinVerification
                                      ? AppColors.dengerColor
                                      : Colors.transparent,
                              inactiveColor:
                                  controller.hasErrorOnPinVerification
                                      ? AppColors.dengerColor
                                      : Colors.transparent,
                            ),
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            animationDuration: Duration(milliseconds: 200),
                            backgroundColor: Colors.transparent,
                            enableActiveFill: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: _pinCodeTEController,
                            appContext: context,
                            onChanged: (value) {
                              if (controller.hasErrorOnPinVerification) {
                                controller.hasErrorOnPinVerification = false;
                              }
                            },
                          ),
                    ),
                    const SizedBox(height: 19),

                    GetBuilder<ForgetPasswordController>(
                      builder:
                          (controller) => ElevatedButton(
                            onPressed:
                                controller.isPinVerifierLoading
                                    ? null
                                    : () async => await _onSubmit(
                                      context,
                                      email,
                                      _pinCodeTEController.text,
                                    ),
                            child:
                                controller.isPinVerifierLoading
                                    ? const Spinner()
                                    : const Text("Verify"),
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

  void _onTapSignIn() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  Future<void> _onSubmit(
    BuildContext context,
    String email,
    String code,
  ) async {
    if (code.trim().length < 6) {
      _triggerError();
      return;
    }

    final response = await _forgetPasswordController.recoverVerifyPin(
      email: email,
      pin: code,
    );

    if (!context.mounted) return;

    if (response) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.resetPassword,
        arguments: {"email": email, "code": code},
      );
    } else {
      _triggerError();
    }
  }

  void _triggerError() {
    _errorController.add(ErrorAnimationType.shake);
    _forgetPasswordController.hasErrorOnPinVerification = true;
  }
}

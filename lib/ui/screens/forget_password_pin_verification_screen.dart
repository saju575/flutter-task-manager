import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/routes/app_routes.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/spiner.dart';

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

  late bool _hasError = false;
  late bool _isSubmitting = false;

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
                    PinCodeTextField(
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
                        activeFillColor: Colors.white,
                        selectedFillColor: AppColors.whiteColor,
                        inactiveFillColor: AppColors.whiteColor,
                        borderWidth: 0,
                        activeColor:
                            _hasError
                                ? AppColors.dengerColor
                                : Colors.transparent,
                        selectedColor:
                            _hasError
                                ? AppColors.dengerColor
                                : Colors.transparent,
                        inactiveColor:
                            _hasError
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _pinCodeTEController,
                      appContext: context,
                      onChanged: (value) {
                        if (_hasError) {
                          setState(() {
                            _hasError = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 19),

                    ElevatedButton(
                      onPressed:
                          _isSubmitting
                              ? null
                              : () async => await _onSubmit(
                                context,
                                email,
                                _pinCodeTEController.text,
                              ),
                      child:
                          _isSubmitting
                              ? const Spinner()
                              : const Text("Verify"),
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

    setState(() => _isSubmitting = true);

    final response = await NetworkClient.getRequest(
      url: Urls.recoverVerifyOtp(email, code),
    );

    if (!context.mounted) return;

    setState(() => _isSubmitting = false);

    if (response.isSuccess) {
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
    setState(() => _hasError = true);
  }
}

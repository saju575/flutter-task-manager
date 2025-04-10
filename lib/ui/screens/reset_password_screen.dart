import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/utils/input_validator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/spiner.dart';

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

  late bool _isPasswordHidden = true;
  late bool _isConfirmPasswordHidden = true;
  late bool _isLoading = false;

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

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      obscureText: _isPasswordHidden,
                      validator: InputValidator.validatePassword,
                      controller: _passwordTExtController,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                        suffixIcon: IconButton(
                          onPressed: _onTapPasswordHide,
                          icon: Icon(
                            _isPasswordHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _confirmPasswordTExtController,
                      validator:
                          (String? value) =>
                              InputValidator.validateConfirmPassword(
                                value,
                                _passwordTExtController.text,
                              ),
                      obscureText: _isConfirmPasswordHidden,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                        suffixIcon: IconButton(
                          onPressed: _onTapConfirmPasswordHide,
                          icon: Icon(
                            _isConfirmPasswordHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _onTapSubmitButton,
                      child:
                          _isLoading ? const Spinner() : const Text("Confirm"),
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

  void _onTapPasswordHide() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void _onTapConfirmPasswordHide() {
    setState(() {
      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    });
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

    setState(() {
      _isLoading = true;
    });

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.resetRecoverPassword,
      body: {
        "email": argumentData["email"],
        "OTP": argumentData["code"],
        "password": _passwordTExtController.text,
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    response.isSuccess
        ? Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        )
        : showSnackBarMessage(context, message: response.errorMessage);
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/routes/app_routes.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/utils/input_validator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTExtController = TextEditingController();
  final TextEditingController _passwordTExtController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _isPasswordHidden = true;
  bool _isLoginInProgress = false;
  @override
  void dispose() {
    _emailTExtController.dispose();
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
                      "Get Started With",
                      style: TextTheme.of(context).titleLarge,
                    ),

                    const SizedBox(height: 19),

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

                    const SizedBox(height: 13),

                    TextFormField(
                      controller: _passwordTExtController,
                      obscureText: _isPasswordHidden,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: InputValidator.validatePassword,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: _onTapPasswordHide,
                          icon: Icon(
                            _isPasswordHidden
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.textColor,
                          ),
                        ),
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                      ),
                    ),

                    const SizedBox(height: 18),

                    ElevatedButton(
                      onPressed: _onTapSignInButton,
                      child:
                          _isLoginInProgress
                              ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                  strokeWidth: 2,
                                ),
                              )
                              : Icon(Icons.arrow_forward),
                    ),
                    const SizedBox(height: 73),

                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _onTapForgotPassword,
                            child: Text(
                              "Forgot Password?",
                              style: TextTheme.of(
                                context,
                              ).bodySmall?.copyWith(color: AppColors.textColor),
                            ),
                          ),

                          const SizedBox(height: 7),

                          RichText(
                            text: TextSpan(
                              style: TextTheme.of(context).bodySmall?.copyWith(
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextTheme.of(
                                    context,
                                  ).bodySmall?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = _onTapSignUp,
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

  void _onTapSignInButton() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoginInProgress = true;
    });
    Map<String, dynamic> requestBody = {
      "email": _emailTExtController.text.trim(),
      "password": _passwordTExtController.text,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.login,
      body: requestBody,
    );
    setState(() {
      _isLoginInProgress = false;
    });
    if (!mounted) return;
    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.data);

      AuthController.saveUserInformation(
        loginModel.token,
        loginModel.userData!,
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (predicate) => false,
      );
    } else {
      showSnackBarMessage(
        context,
        message: response.errorMessage,
        isError: true,
      );
    }
  }

  void _onTapForgotPassword() {
    Navigator.pushNamed(context, AppRoutes.forgetPassword);
  }

  void _onTapSignUp() {
    Navigator.pushReplacementNamed(context, AppRoutes.signUp);
  }
}

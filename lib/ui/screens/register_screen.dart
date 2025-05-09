import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/routes/app_routes.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/utils/input_validator.dart';
import 'package:task_manager/ui/widgets/password_visbility_icon.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool _isPasswordHidden = true;

  bool _registrationInProgress = false;
  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _phoneTEController.dispose();
    _passwordTEController.dispose();
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
                      "Join With Us",
                      style: TextTheme.of(context).titleLarge,
                    ),

                    const SizedBox(height: 19),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTEController,
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
                      textInputAction: TextInputAction.next,
                      controller: _firstNameTEController,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "First Name",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: InputValidator.validateFirstName,
                    ),

                    const SizedBox(height: 13),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _lastNameTEController,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: InputValidator.validateLastName,
                    ),

                    const SizedBox(height: 13),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _phoneTEController,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: "Mobile",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                      ),

                      validator: InputValidator.validatePhone,
                    ),

                    const SizedBox(height: 13),

                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: _isPasswordHidden,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: PasswordVisbilityIcon(
                          isPasswordHidden: _isPasswordHidden,
                          onTapPasswordHide: _onTapPasswordHide,
                        ),
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 16),
                        ),
                      ),
                      validator: InputValidator.validatePassword,
                    ),

                    const SizedBox(height: 18),

                    ElevatedButton(
                      onPressed: _onTapSubmitRegister,
                      child:
                          _registrationInProgress
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

                    const SizedBox(height: 26),

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

  void _onTapSubmitRegister() {
    if (_formKey.currentState!.validate()) {
      _registerUser();
    }
  }

  Future<void> _registerUser() async {
    setState(() {
      _registrationInProgress = true;
    });
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _phoneTEController.text.trim(),
      "password": _passwordTEController.text,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.register,
      body: requestBody,
    );
    setState(() {
      _registrationInProgress = false;
    });
    if (!mounted) return;
    showSnackBarMessage(
      context,
      message:
          response.isSuccess
              ? "User Registered Successfully"
              : response.errorMessage,
      isError: !response.isSuccess,
    );
    if (response.isSuccess) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  void _onTapSignIn() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}

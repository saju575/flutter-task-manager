import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/utils/input_validator.dart';
import 'package:task_manager/ui/widgets/password_visbility_icon.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/spiner.dart';
import 'package:task_manager/ui/widgets/task_manager_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<TaskManagerAppBarState> _taskManagerAppBarKey =
      GlobalKey<TaskManagerAppBarState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  late bool isLoading = false;
  late bool _isPasswordHidden = true;

  @override
  void initState() {
    super.initState();
    UserModel? userModel = AuthController.userModel;
    _emailTEController.text = userModel?.email ?? "";
    _firstNameTEController.text = userModel?.firstName ?? "";
    _lastNameTEController.text = userModel?.lastName ?? "";
    _phoneTEController.text = userModel?.mobile ?? "";
  }

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
      appBar: TaskManagerAppBar(key: _taskManagerAppBarKey),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_avatar()],
                    ),

                    const SizedBox(height: 19),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTEController,
                      style: TextStyle(fontSize: 14),
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                      ),
                    ),

                    const SizedBox(height: 13),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _firstNameTEController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(fontSize: 14),
                      validator: InputValidator.validateFirstName,
                      decoration: InputDecoration(
                        hintText: "First Name",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                      ),
                    ),

                    const SizedBox(height: 13),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _lastNameTEController,
                      validator: InputValidator.validateLastName,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Last Name",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                      ),
                    ),

                    const SizedBox(height: 13),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _phoneTEController,
                      keyboardType: TextInputType.phone,
                      validator: InputValidator.validatePhone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Mobile",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                      ),
                    ),

                    const SizedBox(height: 13),

                    TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _passwordTEController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: _isPasswordHidden,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Set New Password",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                        suffixIcon: PasswordVisbilityIcon(
                          isPasswordHidden: _isPasswordHidden,
                          onTapPasswordHide: _onTapPasswordHide,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: isLoading ? null : _onTapUpdate,
                      child: isLoading ? const Spinner() : const Text("Update"),
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

  Widget _avatar() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 40,
        backgroundImage:
            _pickedImage != null
                ? FileImage(File(_pickedImage!.path))
                : (AuthController.userModel?.photo != null &&
                    AuthController.userModel?.photo != "")
                ? MemoryImage(
                  base64Decode(AuthController.userModel?.photo ?? ""),
                )
                : null,
      ),
    );
  }

  void _onTapUpdate() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  void _onTapPasswordHide() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void _clearPaswordInputField() {
    _passwordTEController.clear();
  }

  Future<void> _updateProfile() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> requestBody = {
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _phoneTEController.text.trim(),
    };
    if (_passwordTEController.text.isNotEmpty) {
      requestBody["password"] = _passwordTEController.text;
    }
    if (_pickedImage != null) {
      List<int> imageByte = await _pickedImage!.readAsBytes();
      requestBody["photo"] = base64Encode(imageByte);
    }

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.updateProfile,
      body: requestBody,
      token: true,
    );
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (response.isSuccess) {
      _clearPaswordInputField();
      await AuthController.setUserInformation(newUser: requestBody);
      _taskManagerAppBarKey.currentState?.setState(() {});
      if (!mounted) return;
      showSnackBarMessage(context, message: "Profile Updated Successfully");
    } else {
      showSnackBarMessage(
        context,
        isError: true,
        message: response.errorMessage,
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:task_manager/data/enums/task_status.dart';
import 'package:task_manager/data/services/network_client.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/utils/input_validator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_manager_app_bar.dart';
import 'package:task_manager/ui/widgets/spiner.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _subjectTExtController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool _isLoading = false;

  @override
  void dispose() {
    _subjectTExtController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TaskManagerAppBar(),
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
                      "Add New Task",
                      style: TextTheme.of(context).titleLarge,
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      controller: _subjectTExtController,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      validator: InputValidator.validateTaskTitle,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Subject",
                        prefix: Padding(padding: EdgeInsets.only(left: 16)),
                      ),
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _descriptionTEController,
                      maxLines: 10,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Description",
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 21),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _onTapSubmitButton,
                      child:
                          _isLoading
                              ? const Spinner()
                              : const Icon(Icons.arrow_forward),
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
      _addNewTask();
    }
  }

  void _clearInputFields() {
    _subjectTExtController.clear();
    _descriptionTEController.clear();
  }

  Future<void> _addNewTask() async {
    Map<String, String> requestbody = {
      "title": _subjectTExtController.text,
      "description": _descriptionTEController.text,
      "status": TaskStatus.newTask.label,
    };

    setState(() {
      _isLoading = true;
    });

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.createTask,
      body: requestbody,
      token: true,
    );
    setState(() {
      _isLoading = false;
    });
    _clearInputFields();
    if (!mounted) return;
    response.isSuccess
        ? showSnackBarMessage(context, message: "Successfuly created new Task")
        : showSnackBarMessage(
          context,
          isError: true,
          message: response.errorMessage,
        );
  }
}

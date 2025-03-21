import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/screens/cancelled_screen.dart';
import 'package:task_manager/ui/screens/completed_screen.dart';
import 'package:task_manager/ui/screens/forget_password_pin_verification_screen.dart';
import 'package:task_manager/ui/screens/forget_password_verify_email_screen.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/progress_screen.dart';
import 'package:task_manager/ui/screens/register_screen.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String signUp = '/signup';

  static const String forgetPassword = '/forgetPassword';
  static const String forgetPasswordPinVerification =
      '/forgetPasswordPinVerification';
  static const String resetPassword = '/resetPassword';

  static const String updateProfile = '/updateProfile';
  static const String addNewTask = '/addNewTask';
  static const String newTasks = '/newTasks';
  static const String cancelTasks = '/cancelTasks';
  static const String completedTasks = '/completedTasks';
  static const String progressTasks = '/progressTasks';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const MainBottomNavScreen(),
    login: (context) => const LoginScreen(),
    signUp: (context) => const RegisterScreen(),
    forgetPassword: (context) => const ForgetPasswordVerifyEmailScreen(),
    forgetPasswordPinVerification:
        (context) => const ForgetPasswordPinVerificationScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
    updateProfile: (context) => const UpdateProfileScreen(),
    addNewTask: (context) => const AddNewTaskScreen(),
    newTasks: (context) => const NewTaskScreen(),
    cancelTasks: (context) => const CancelledScreen(),
    completedTasks: (context) => const CompletedScreen(),
    progressTasks: (context) => const ProgressScreen(),
  };
}

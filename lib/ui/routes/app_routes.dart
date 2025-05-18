import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/screens/canceled_screen.dart';
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
  static const String splash = '/';
  static const String home = '/mainBottomNavScreen';
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
    cancelTasks: (context) => const CanceledScreen(),
    completedTasks: (context) => const CompletedScreen(),
    progressTasks: (context) => const ProgressScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    WidgetBuilder builder;

    switch (settings.name) {
      case splash:
        builder = (context) => const SplashScreen();
        break;
      case home:
        builder = (context) => const MainBottomNavScreen();
        break;
      case login:
        builder = (context) => const LoginScreen();
        break;
      case signUp:
        builder = (context) => const RegisterScreen();
        break;
      case forgetPassword:
        builder = (context) => const ForgetPasswordVerifyEmailScreen();
        break;
      case forgetPasswordPinVerification:
        builder = (context) => const ForgetPasswordPinVerificationScreen();
        break;
      case resetPassword:
        builder = (context) => const ResetPasswordScreen();
        break;
      case updateProfile:
        builder = (context) => const UpdateProfileScreen();
        break;
      case addNewTask:
        builder = (context) => const AddNewTaskScreen();
        break;
      case newTasks:
        builder = (context) => const NewTaskScreen();
        break;
      case cancelTasks:
        builder = (context) => const CanceledScreen();
        break;
      case completedTasks:
        builder = (context) => const CompletedScreen();
        break;
      case progressTasks:
        builder = (context) => const ProgressScreen();
        break;
      default:
        builder = (context) => const SplashScreen();
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        final fadeTween = Tween<double>(
          begin: 0.5,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400), // smoother pace
      settings: settings,
    );
  }
}

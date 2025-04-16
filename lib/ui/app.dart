import 'package:flutter/material.dart';
import 'package:task_manager/ui/routes/app_routes.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splash,
      navigatorObservers: [routeObserver],

      theme: ThemeData(
        primaryColor: AppColors.primaryColor, // Primary color of the app
        scaffoldBackgroundColor: AppColors.whiteColor, // Background color
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
        ),

        fontFamily: 'Poppins',

        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryColor,
          ),
          bodySmall: TextStyle(fontSize: 12),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.grayColor),
          bodyLarge: TextStyle(fontSize: 16),
        ),

        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: AppColors.hintColor,
          ),
          fillColor: AppColors.whiteColor,
          filled: true,
          contentPadding: EdgeInsets.only(left: 0, right: 16),
          border: _getDynamicBorder(4),
          enabledBorder: _getDynamicBorder(4),
          errorBorder: _getDynamicBorder(4),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _getDynamicBorder(double borderRadius) {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}

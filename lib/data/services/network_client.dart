import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:task_manager/data/services/network_logger.dart';
import 'package:task_manager/ui/app.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/routes/app_routes.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic data;
  final String errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.errorMessage = "Something went wrong",
  });
}

class NetworkClient {
  static Future<NetworkResponse> getRequest({
    required String url,
    bool token = false,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': token ? AuthController.token ?? "" : "",
      };

      NetworkLogger.preRequestLog(url, headers: headers);

      Response response = await get(uri, headers: headers);

      NetworkLogger.postRequestLog(
        url,
        response.statusCode,
        responseBody: response.body,
      );
      final decodedJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
        );
      } else if (response.statusCode == 401) {
        _gotoLoginScreen();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: "Un-authorize user. Please login again.",
        );
      } else {
        String errorMessage = decodedJson['data'] ?? "Something went wrong";
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      NetworkLogger.postRequestLog(url, -1, errorMessage: e.toString());

      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
    bool token = false,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'token': token ? AuthController.token ?? "" : "",
      };
      NetworkLogger.preRequestLog(url, body: body, headers: headers);

      Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      NetworkLogger.postRequestLog(
        url,
        response.statusCode,
        headers: response.headers,
        responseBody: response.body,
      );

      final decodedJson = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
        );
      } else if (response.statusCode == 401) {
        _gotoLoginScreen();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: "Un-authorize user. Please login again.",
        );
      } else {
        String errorMessage = decodedJson['data'] ?? "Something went wrong";
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      NetworkLogger.postRequestLog(url, -1, errorMessage: e.toString());

      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<void> _gotoLoginScreen() async {
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(
      TaskManagerApp.navigatorKey.currentContext!,
      AppRoutes.login,
      (route) => false,
    );
  }
}

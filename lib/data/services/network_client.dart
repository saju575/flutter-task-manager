import 'dart:convert';
import 'package:http/http.dart';
import 'package:task_manager/data/services/network_logger.dart';

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
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      NetworkLogger.preRequestLog(url);
      Response response = await get(uri);
      NetworkLogger.postRequestLog(url, response.statusCode);
      final decodedJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
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
  }) async {
    try {
      Uri uri = Uri.parse(url);
      NetworkLogger.preRequestLog(url, body: body);

      Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
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
}

import 'package:logger/logger.dart';

class NetworkLogger {
  static final Logger _logger = Logger();

  static void preRequestLog(String url, {Map<String, dynamic>? body}) {
    _logger.i(
      'URL=> $url\n'
      'Body=> $body',
    );
  }

  static void postRequestLog(
    String url,
    int statusCode, {
    Map<String, dynamic>? headers,
    dynamic responseBody,
    dynamic errorMessage,
  }) {
    if (errorMessage != null) {
      _logger.e(
        ''
        'Status Code=> $statusCode\n'
        'Error Message=> $errorMessage',
      );
    } else {
      _logger.i(
        ''
        'URL=> $url\n'
        'Status Code=> $statusCode\n'
        'Headers=> $headers\n'
        'Response=> $responseBody',
      );
    }
  }
}

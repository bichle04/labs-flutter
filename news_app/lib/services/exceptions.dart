// Custom exception cho News API
class NewsApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  NewsApiException(this.message, {this.code, this.statusCode});

  @override
  String toString() {
    return 'NewsApiException: $message';
  }
}

// Exception cho lỗi mạng
class NetworkException extends NewsApiException {
  NetworkException(String message) : super(message, code: 'NETWORK_ERROR');
}

// Exception cho lỗi timeout
class TimeoutException extends NewsApiException {
  TimeoutException(String message) : super(message, code: 'TIMEOUT_ERROR');
}

// Exception cho lỗi parse dữ liệu
class ParseException extends NewsApiException {
  ParseException(String message) : super(message, code: 'PARSE_ERROR');
}

// Exception cho lỗi API key
class ApiKeyException extends NewsApiException {
  ApiKeyException(String message) : super(message, code: 'API_KEY_ERROR');
}

// Exception cho lỗi rate limit
class RateLimitException extends NewsApiException {
  RateLimitException(String message) : super(message, code: 'RATE_LIMIT_ERROR');
}

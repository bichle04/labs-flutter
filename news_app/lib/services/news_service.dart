import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../config/api_config.dart';

class NewsService {
  static const Duration _timeout = Duration(seconds: 10);

  // Lấy tin tức hàng đầu
  Future<NewsResponse> getTopHeadlines({
    String country = ApiConfig.defaultCountry,
    String category = ApiConfig.defaultCategory,
    int pageSize = ApiConfig.defaultPageSize,
    int page = 1,
  }) async {
    try {
      final url =
          Uri.parse(
            '${ApiConfig.newsApiBaseUrl}${ApiConfig.topHeadlinesEndpoint}',
          ).replace(
            queryParameters: {
              'apiKey': ApiConfig.newsApiKey,
              'country': country,
              'category': category,
              'pageSize': pageSize.toString(),
              'page': page.toString(),
            },
          );

      final response = await http.get(url).timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Lấy tin tức theo danh mục
  Future<NewsResponse> getNewsByCategory({
    required String category,
    String country = ApiConfig.defaultCountry,
    int pageSize = ApiConfig.defaultPageSize,
    int page = 1,
  }) async {
    try {
      final url =
          Uri.parse(
            '${ApiConfig.newsApiBaseUrl}${ApiConfig.topHeadlinesEndpoint}',
          ).replace(
            queryParameters: {
              'apiKey': ApiConfig.newsApiKey,
              'country': country,
              'category': category,
              'pageSize': pageSize.toString(),
              'page': page.toString(),
            },
          );

      final response = await http.get(url).timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Xử lý response từ API
  NewsResponse _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return NewsResponse.fromJson(jsonData);
    } else {
      return NewsResponse(
        status: 'error',
        totalResults: 0,
        articles: [],
        code: response.statusCode.toString(),
        message: _getErrorMessage(response.statusCode),
      );
    }
  }

  // Xử lý lỗi
  NewsResponse _handleError(dynamic error) {
    String errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại.';

    if (error is SocketException) {
      errorMessage = 'Không có kết nối internet.';
    } else if (error.toString().contains('TimeoutException')) {
      errorMessage = 'Kết nối quá chậm.';
    }

    return NewsResponse(
      status: 'error',
      totalResults: 0,
      articles: [],
      code: 'ERROR',
      message: errorMessage,
    );
  }

  // Lấy thông báo lỗi dựa trên status code
  String _getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Yêu cầu không hợp lệ.';
      case 401:
        return 'API key không hợp lệ.';
      case 429:
        return 'Đã vượt quá giới hạn số lần gọi API.';
      case 500:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      default:
        return 'Đã xảy ra lỗi. Mã lỗi: $statusCode';
    }
  }

  // Danh sách các danh mục tin tức có sẵn
  static const List<String> availableCategories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  // Danh sách các quốc gia có sẵn
  static const Map<String, String> availableCountries = {
    'us': 'United States',
    'gb': 'United Kingdom',
    'ca': 'Canada',
    'au': 'Australia',
    'de': 'Germany',
    'fr': 'France',
    'jp': 'Japan',
    'kr': 'South Korea',
  };
}

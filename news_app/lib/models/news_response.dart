import 'article.dart';

class NewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;
  final String? code;
  final String? message;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
    this.code,
    this.message,
  });

  // Tạo NewsResponse từ JSON response của API
  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      status: json['status'] ?? '',
      totalResults: json['totalResults'] ?? 0,
      articles: json['articles'] != null
          ? (json['articles'] as List)
                .map((articleJson) => Article.fromJson(articleJson))
                .toList()
          : [],
      code: json['code'],
      message: json['message'],
    );
  }

  // Chuyển NewsResponse thành JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles.map((article) => article.toJson()).toList(),
      'code': code,
      'message': message,
    };
  }

  // Getter để kiểm tra response có thành công không
  bool get isSuccess {
    return status == 'ok';
  }

  // Getter để kiểm tra có lỗi không
  bool get hasError {
    return status == 'error';
  }

  // Getter để lấy thông báo lỗi
  String get errorMessage {
    if (hasError) {
      return message ?? 'Đã xảy ra lỗi không xác định';
    }
    return '';
  }
}

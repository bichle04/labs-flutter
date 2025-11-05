class Article {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  final Source? source;
  final String? author;

  Article({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.source,
    this.author,
  });

  // Tạo Article từ JSON response của API
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
      content: json['content'] as String?,
      source: json['source'] != null ? Source.fromJson(json['source']) : null,
      author: json['author'] as String?,
    );
  }

  // Chuyển Article thành JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt?.toIso8601String(),
      'content': content,
      'source': source?.toJson(),
      'author': author,
    };
  }

  // Getter để lấy thời gian đăng bài dễ đọc
  String get formattedPublishedAt {
    if (publishedAt == null) return 'Không có thông tin';

    final now = DateTime.now();
    final difference = now.difference(publishedAt!);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  // Getter để lấy tên nguồn tin
  String get sourceName {
    return source?.name ?? 'Không rõ nguồn';
  }

  // Getter để kiểm tra có ảnh hay không
  bool get hasImage {
    return urlToImage != null && urlToImage!.isNotEmpty;
  }
}

class Source {
  final String? id;
  final String? name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'] as String?, name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareArticle(context),
            tooltip: 'Chia sẻ',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Ảnh header nếu có
            if (article.hasImage) _buildHeaderImage(),

            // Nội dung bài báo
            _buildArticleContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      child: Image.network(
        article.urlToImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thông tin bài báo
          _buildArticleInfo(),
          const SizedBox(height: 20),

          // Tiêu đề
          _buildTitle(context),
          const SizedBox(height: 16),

          // Mô tả
          _buildDescription(context),
          const SizedBox(height: 20),

          // Nội dung
          _buildContent(context),
          const SizedBox(height: 24),

          // Liên kết đến bài gốc
          _buildOriginalLink(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildArticleInfo() {
    return Row(
      children: [
        // Source
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            article.sourceName,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const Spacer(),

        // Time
        Text(
          article.formattedPublishedAt,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (article.title == null) return const SizedBox.shrink();

    return Text(
      article.title!,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    if (article.description == null) return const SizedBox.shrink();

    return Text(
      article.description!,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700], height: 1.5),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (article.content == null) return const SizedBox.shrink();

    // Loại bỏ phần [+xxx chars] ở cuối content
    String content = article.content!;
    final regex = RegExp(r'\[\+\d+\s+chars\]$');
    content = content.replaceAll(regex, '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nội dung',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildOriginalLink(BuildContext context) {
    if (article.url == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đọc bài gốc',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _openOriginalArticle(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.open_in_new, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Xem bài báo đầy đủ trên ${article.sourceName}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _shareArticle(BuildContext context) {
    final text =
        '''
${article.title ?? 'Bài báo mới'}

${article.description ?? ''}

Đọc thêm: ${article.url ?? ''}
    '''
            .trim();

    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép liên kết bài báo'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openOriginalArticle(BuildContext context) {
    if (article.url != null) {
      // Copy URL to clipboard
      Clipboard.setData(ClipboardData(text: article.url!));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã sao chép liên kết bài gốc'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

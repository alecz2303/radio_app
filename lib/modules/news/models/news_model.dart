class NewsModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime date;
  final String content;

  NewsModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.date,
    required this.content,
  });
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    // Helper para limpiar HTML tags del excerpt
    String stripHtml(String htmlString) {
      final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
      return htmlString.replaceAll(exp, '').trim();
    }

    // Obtener imagen destacada
    String getImageUrl(Map<String, dynamic> json) {
      try {
        // Intentar obtener desde Yoast SEO (más confiable en este caso)
        if (json['yoast_head_json'] != null && 
            json['yoast_head_json']['og_image'] != null) {
          final images = json['yoast_head_json']['og_image'] as List;
          if (images.isNotEmpty) {
            return images[0]['url'] ?? '';
          }
        }

        // Intentar obtener desde _embedded (estándar WP)
        if (json['_embedded'] != null &&
            json['_embedded']['wp:featuredmedia'] != null &&
            (json['_embedded']['wp:featuredmedia'] as List).isNotEmpty) {
          return json['_embedded']['wp:featuredmedia'][0]['source_url'] ?? '';
        }
      } catch (e) {
        // Fallback o log
      }
      return 'https://via.placeholder.com/800x400?text=No+Image'; // Placeholder
    }

    return NewsModel(
      id: json['id'].toString(),
      title: json['title']['rendered'] ?? 'Sin título',
      subtitle: stripHtml(json['excerpt']['rendered'] ?? ''),
      imageUrl: getImageUrl(json),
      date: DateTime.parse(json['date']),
      content: json['content']['rendered'] ?? '',
    );
  }
}

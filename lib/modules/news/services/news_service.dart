import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const String _baseUrl = 'https://diariodechiapas.com/wp-json/wp/v2';

  Future<List<NewsModel>> getNews() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/posts?_embed&per_page=10'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => NewsModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar noticias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

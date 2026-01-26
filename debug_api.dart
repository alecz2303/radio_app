import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('https://diariodechiapas.com/wp-json/wp/v2/posts?_embed&per_page=1');
  print('Fetching from: $url');
  
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final post = data[0];
        print('Post ID: ${post['id']}');
        
        print('Keys: ${post.keys.toList()}');
        print('Featured Media ID: ${post['featured_media']}');
        
        if (post['yoast_head_json'] != null) {
          print('yoast_head_json found');
          final yoast = post['yoast_head_json'];
          if (yoast['og_image'] != null) {
            final images = yoast['og_image'] as List;
            if (images.isNotEmpty) {
              print('Yoast Image: ${images[0]['url']}');
            }
          }
        }
      } else {
        print('No posts found');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}

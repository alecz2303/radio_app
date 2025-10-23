import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias')),
      body: ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) => Card(
          color: AppColors.card,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              'Noticia ${i + 1}',
              style: AppTextStyles.sectionTitle,
            ),
            subtitle: const Text(
              'Esta es una muestra de cómo se verían las noticias.',
              style: AppTextStyles.subtitle,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}

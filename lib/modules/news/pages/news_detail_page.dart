import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/news_model.dart';
import '../../../core/widgets/bottom_now_playing_bar.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsModel news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: const Color(0xFF1E1E1E),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'news_image_${news.id}',
                        child: Image.network(
                          news.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(Icons.image_not_supported, color: Colors.white54),
                              ),
                            );
                          },
                        ),
                      ),
                      // Gradiente para mejorar legibilidad del botón atrás
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black54,
                            ],
                            stops: [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fecha
                      Text(
                        _formatDate(news.date),
                        style: GoogleFonts.outfit(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Título
                      Text(
                        news.title,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Contenido HTML
                      Html(
                        data: news.content,
                        style: {
                          "body": Style(
                            color: Colors.white70,
                            fontFamily: GoogleFonts.outfit().fontFamily,
                            fontSize: FontSize(16),
                            lineHeight: const LineHeight(1.6),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          "p": Style(
                            margin: Margins.only(bottom: 16),
                          ),
                          "a": Style(
                            color: Colors.blueAccent,
                            textDecoration: TextDecoration.none,
                          ),
                          "img": Style(
                            width: Width(100, Unit.percent),
                            height: Height.auto(),
                            margin: Margins.symmetric(vertical: 16),
                          ),
                          "h1": Style(color: Colors.white, fontSize: FontSize(22)),
                          "h2": Style(color: Colors.white, fontSize: FontSize(20)),
                          "h3": Style(color: Colors.white, fontSize: FontSize(18)),
                          "h4": Style(color: Colors.white, fontSize: FontSize(16)),
                          "h5": Style(color: Colors.white, fontSize: FontSize(14)),
                          "h6": Style(color: Colors.white, fontSize: FontSize(12)),
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Player Bar persistente
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNowPlayingBar(),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

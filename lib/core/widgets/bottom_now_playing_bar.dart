import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/radio_player_provider.dart';

class BottomNowPlayingBar extends StatefulWidget {
  const BottomNowPlayingBar({super.key});

  @override
  State<BottomNowPlayingBar> createState() => _BottomNowPlayingBarState();
}

class _BottomNowPlayingBarState extends State<BottomNowPlayingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<RadioPlayerProvider>();

    if (!player.hasStation) return const SizedBox.shrink();

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.85),
            border: const Border(
              top: BorderSide(color: Colors.white10, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // 🎵 Logo de la estación
              if (player.currentStation?.logoUrl != null)
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: player.currentStation!.logoUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey[800],
                        child: const Icon(Icons.radio, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 16),

              // 📻 Nombre del canal
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.currentChannel?.name ?? '',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      player.currentStation?.name ?? '',
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),

              // 🔊 Onda animada
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  if (!player.isPlaying) return const SizedBox(width: 10);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (i) {
                      final height = 12 +
                          math.sin((_controller.value * 2 * math.pi) + (i * 0.8)) *
                              10;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          width: 4,
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(width: 16),

              // ▶️ / ⏸️ Botón play-pause
              GestureDetector(
                onTap: () => player.togglePlayPause(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

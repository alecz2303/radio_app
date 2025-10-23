import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/radio_player_provider.dart';

class BottomNowPlayingBar extends StatelessWidget {
  const BottomNowPlayingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<RadioPlayerProvider>();

    // 🔒 Si no hay estación activa, no muestra nada
    if (!player.hasStation) return const SizedBox.shrink();

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black87,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.radio, color: Colors.white),
        title: Text(
          player.currentStation?.name ?? '',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          player.currentChannel?.name ?? '',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AnimatedBars(isPlaying: player.isPlaying),
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(
                player.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: Colors.white,
                size: 36,
              ),
              onPressed: player.togglePlayPause,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedBars extends StatefulWidget {
  final bool isPlaying;
  const _AnimatedBars({required this.isPlaying});

  @override
  State<_AnimatedBars> createState() => _AnimatedBarsState();
}

class _AnimatedBarsState extends State<_AnimatedBars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _AnimatedBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0.3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return SizedBox(
          width: 16,
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) {
              final double height = (6 + 12 * (_controller.value - (i * 0.1)).abs().clamp(0, 1)).toDouble();
              return Container(
                width: 3,
                height: height.toDouble(),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

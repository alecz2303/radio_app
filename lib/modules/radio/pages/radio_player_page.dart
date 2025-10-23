import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/radio_player_provider.dart';
import '../../radio/models/station.dart';
import '../../radio/models/channel.dart';

class RadioPlayerPage extends StatefulWidget {
  final Station station;

  const RadioPlayerPage({super.key, required this.station});

  @override
  State<RadioPlayerPage> createState() => _RadioPlayerPageState();
}

class _RadioPlayerPageState extends State<RadioPlayerPage> {
  Channel? _selected;

  @override
  Widget build(BuildContext context) {
    final player = context.watch<RadioPlayerProvider>();
    final isPlaying = player.isPlaying &&
        player.currentStation?.id == widget.station.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.name),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen de la estación
            ClipRRect(
              borderRadius: BorderRadius.circular(120),
              child: Image.network(
                widget.station.logoUrl,
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              widget.station.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _selected?.name ?? 'Selecciona un canal para escuchar',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Lista de canales
            ...widget.station.channels.map(
              (c) => ListTile(
                leading: Icon(
                  Icons.radio,
                  color: _selected?.id == c.id
                      ? Colors.greenAccent
                      : Colors.grey,
                ),
                title: Text(c.name),
                onTap: () async {
                  setState(() => _selected = c);
                  // 🔄 Cambia al nuevo canal en caliente
                  final player = context.read<RadioPlayerProvider>();
                  await player.play(widget.station, c);
                },
              ),
            ),

            const SizedBox(height: 30),

            // Botón Play/Pause
            IconButton(
              iconSize: 80,
              color: Colors.greenAccent,
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
              ),
              onPressed: () async {
                if (_selected == null) return;

                // Si la estación actual es la misma, solo alterna Play/Pause
                if (player.currentStation?.id == widget.station.id) {
                  await player.togglePlayPause();
                } else {
                  await player.play(widget.station, _selected!);
                }
              },
            ),

            const SizedBox(height: 16),

            // Indicador de estado
            Text(
              isPlaying ? 'Reproduciendo...' : 'Pausado',
              style: TextStyle(
                color: isPlaying ? Colors.greenAccent : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

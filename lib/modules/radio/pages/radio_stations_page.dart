import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/radio_player_provider.dart';
import '../models/station.dart';
import '../models/channel.dart';
import '../../../core/widgets/bottom_now_playing_bar.dart';
import '../services/api_service.dart';
import 'dart:ui';

class RadioStationsPage extends StatefulWidget {
  const RadioStationsPage({super.key});

  @override
  State<RadioStationsPage> createState() => _RadioStationsPageState();
}

class _RadioStationsPageState extends State<RadioStationsPage> {
  late Future<List<Station>> _stationsFuture;

  @override
  void initState() {
    super.initState();
    _stationsFuture = ApiService().fetchStations();
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<RadioPlayerProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'La Radio del Diario',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Station>>(
        future: _stationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay estaciones disponibles',
                  style: TextStyle(color: Colors.white)));
          }

          // ✅ Obtener todas las estaciones y aplanar los canales
          final stations = snapshot.data!;
          final allChannels = <Map<String, dynamic>>[];

          for (final s in stations) {
            for (final c in s.channels) {
              allChannels.add({'station': s, 'channel': c});
            }
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 por fila
                    childAspectRatio: 1.0,
                  ),
                  itemCount: allChannels.length,
                  itemBuilder: (context, index) {
                    final s = allChannels[index]['station'] as Station;
                    final c = allChannels[index]['channel'] as Channel;

                    final imageUrl = (c.backupUrl?.trim().isNotEmpty ?? false)
                      ? c.backupUrl!
                      : s.logoUrl;

                    return GestureDetector(
                      onTap: () => player.play(s, c),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // 📸 Imagen de fondo (compatible con WebP)
                          FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.jpg', // puedes poner tu logo aquí
                            image: imageUrl,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stack) => const Center(
                              child: Icon(Icons.radio, color: Colors.white38, size: 60),
                            ),
                          ),

                          // 🌈 Capa de degradado y blur
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.0),
                                  Colors.black.withOpacity(0.4),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                            child: Container(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ),

                          // 🎚️ Texto del canal
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              c.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const BottomNowPlayingBar(),
            ],
          );
        },
      ),
    );
  }
}

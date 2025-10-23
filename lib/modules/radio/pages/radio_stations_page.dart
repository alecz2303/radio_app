import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/radio_player_provider.dart';
import '../models/station.dart';
import '../models/channel.dart';
import '../../../core/widgets/bottom_now_playing_bar.dart';
import '../services/api_service.dart';

class RadioStationsPage extends StatefulWidget {
  const RadioStationsPage({super.key});

  @override
  State<RadioStationsPage> createState() => _RadioStationsPageState();
}

class _RadioStationsPageState extends State<RadioStationsPage>
    with SingleTickerProviderStateMixin {
  late Future<List<Station>> _stationsFuture;
  int? _activeIndex;
  Color _backgroundColor = const Color(0xFF1E1E1E);

  // 🎨 Paleta de colores "mood"
  final List<Color> _moodColors = [
    const Color(0xFF1E1E1E), // gris oscuro
    const Color(0xFF2B2B30), // gris cálido
    const Color(0xFF3A2E2E), // vino tenue
    const Color(0xFF2E3A3A), // verde grisáceo
    const Color(0xFF3B3146), // violeta suave
  ];

  @override
  void initState() {
    super.initState();
    _stationsFuture = ApiService().fetchStations();
  }

  void _updateMood(int index) {
    final newColor = _moodColors[index % _moodColors.length];
    setState(() => _backgroundColor = newColor);
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<RadioPlayerProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        color: _backgroundColor,
        child: SafeArea(
          child: FutureBuilder<List<Station>>(
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
                      style: TextStyle(color: Colors.white70)),
                );
              }

              final stations = snapshot.data!;
              final allChannels = <Map<String, dynamic>>[];

              for (final s in stations) {
                for (final c in s.channels) {
                  allChannels.add({'station': s, 'channel': c});
                }
              }

              return Column(
                children: [
                  const SizedBox(height: 20),

                  // 🎙️ Logo y título
                  Column(
                    children: [
                      Hero(
                        tag: 'radio_logo',
                        child: Image.asset(
                          'assets/images/logo_diario.jpg',
                          width: 140,
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'La Radio del Diario',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),

                  // 🎚️ Grid de estaciones
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: allChannels.length,
                      itemBuilder: (context, index) {
                        final s = allChannels[index]['station'] as Station;
                        final c = allChannels[index]['channel'] as Channel;

                        final imageUrl =
                            (c.backupUrl?.trim().isNotEmpty ?? false)
                                ? c.backupUrl!
                                : s.logoUrl;

                        final isActive = player.currentChannel == c;

                        return GestureDetector(
                          onTap: () {
                            player.play(s, c);
                            _updateMood(index);
                            setState(() => _activeIndex = index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white.withOpacity(0.05),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: isActive
                                    ? Colors.greenAccent.shade400
                                    : Colors.white24,
                                width: isActive ? 2.5 : 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // 🖼️ Imagen de fondo
                                  FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/placeholder.jpg',
                                    image: imageUrl,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder:
                                        (context, error, stack) =>
                                            const Center(
                                      child: Icon(Icons.radio,
                                          color: Colors.white38, size: 60),
                                    ),
                                  ),
                                  // 🌈 Degradado sutil
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // 🎵 Nombre del canal
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        c.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 8,
                                              color: Colors.black,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 🔊 Indicador de estación activa
                                  if (isActive)
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.equalizer,
                                          color:
                                              Colors.greenAccent.shade400,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 🎧 Barra inferior
                  const BottomNowPlayingBar(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

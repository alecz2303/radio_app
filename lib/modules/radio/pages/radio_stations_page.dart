import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/radio_player_provider.dart';
import '../models/station.dart';
import '../models/channel.dart';
import '../../../core/widgets/bottom_now_playing_bar.dart';
import '../services/api_service.dart';
import '../widgets/station_card.dart';

class RadioStationsPage extends StatefulWidget {
  const RadioStationsPage({super.key});

  @override
  State<RadioStationsPage> createState() => _RadioStationsPageState();
}

class _RadioStationsPageState extends State<RadioStationsPage> {
  late Future<List<Station>> _stationsFuture;
  
  // 🎨 Paleta de colores "mood"
  final List<Color> _moodColors = [
    const Color(0xFF1E1E1E), // gris oscuro
    const Color(0xFF2B2B30), // gris cálido
    const Color(0xFF3A2E2E), // vino tenue
    const Color(0xFF2E3A3A), // verde grisáceo
    const Color(0xFF3B3146), // violeta suave
  ];

  Color _backgroundColor = const Color(0xFF1E1E1E);

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
      backgroundColor: _backgroundColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        color: _backgroundColor,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              FutureBuilder<List<Station>>(
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
                  final favoriteChannels = <Map<String, dynamic>>[];

                  for (final s in stations) {
                    for (final c in s.channels) {
                      final item = {'station': s, 'channel': c};
                      allChannels.add(item);
                      if (player.isFavorite(s, c)) {
                        favoriteChannels.add(item);
                      }
                    }
                  }

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // 🏷️ AppBar
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        expandedHeight: 120,
                        floating: false,
                        pinned: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: 'radio_logo',
                                child: Image.asset(
                                  'assets/images/logo_diario.jpg',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'La Radio del Diario',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ❤️ Favoritos (si hay)
                      if (favoriteChannels.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                            child: Text(
                              'Favoritos',
                              style: GoogleFonts.outfit(
                                color: Colors.white70,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: favoriteChannels.length,
                              itemBuilder: (context, index) {
                                final s = favoriteChannels[index]['station'] as Station;
                                final c = favoriteChannels[index]['channel'] as Channel;
                                final isActive = player.currentChannel == c;

                                return Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: StationCard(
                                    station: s,
                                    channel: c,
                                    isActive: isActive,
                                    onTap: () {
                                      player.play(s, c);
                                      _updateMood(index);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],

                      // 📻 Todas las estaciones
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(
                            'Todas las Estaciones',
                            style: GoogleFonts.outfit(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // Padding inferior para el player global
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final s = allChannels[index]['station'] as Station;
                              final c = allChannels[index]['channel'] as Channel;
                              final isActive = player.currentChannel == c;

                              return StationCard(
                                station: s,
                                channel: c,
                                isActive: isActive,
                                onTap: () {
                                  player.play(s, c);
                                  _updateMood(index);
                                },
                              );
                            },
                            childCount: allChannels.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              // 🎧 Barra inferior removida (ahora en MainPage)
              const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

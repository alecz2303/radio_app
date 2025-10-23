import 'package:flutter/material.dart';
import '../models/station.dart';
import '../services/api_service.dart';
import '../../../core/widgets/bottom_now_playing_bar.dart';
import 'radio_player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api = ApiService();
  late Future<List<Station>> _stationsFuture;

  @override
  void initState() {
    super.initState();
    _stationsFuture = _api.fetchStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Radio')),
      body: FutureBuilder<List<Station>>(
        future: _stationsFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final stations = snap.data ?? [];
          if (stations.isEmpty) {
            return const Center(child: Text('No hay estaciones.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80), // espacio para la barra
            itemCount: stations.length,
            itemBuilder: (context, i) {
              final s = stations[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(s.logoUrl),
                ),
                title: Text(s.name),
                subtitle: Text(s.slug),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RadioPlayerPage(station: s),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: const BottomNowPlayingBar(),
    );
  }
}

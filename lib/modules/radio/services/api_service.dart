import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/station.dart';
import '../models/channel.dart';

class ApiService {
  final String baseUrl = 'https://radio-api.djira.xyz/api/v1';

  /// 🔹 Obtiene todas las estaciones junto con sus canales
  Future<List<Station>> fetchStations() async {
    final res = await http.get(Uri.parse('$baseUrl/stations'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List<dynamic>;
      return data.map((json) => Station.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener estaciones: ${res.statusCode}');
    }
  }

  /// 🔹 Obtiene los canales de una estación específica
  Future<List<Channel>> fetchChannels(int stationId) async {
    final res = await http.get(Uri.parse('$baseUrl/stations/$stationId'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final channels = data['channels'] as List<dynamic>? ?? [];
      return channels.map((e) => Channel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener canales: ${res.statusCode}');
    }
  }
}

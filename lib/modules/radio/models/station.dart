import 'channel.dart';

class Station {
  final int id;
  final String name;
  final String slug;
  final String logoUrl;
  final List<Channel> channels;

  Station({
    required this.id,
    required this.name,
    required this.slug,
    required this.logoUrl,
    required this.channels,
  });

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        id: json['id'] as int,
        name: json['name'] as String,
        slug: json['slug'] as String? ?? '',
        logoUrl: json['logo_url'] as String? ?? '',
        channels: (json['channels'] as List<dynamic>? ?? [])
            .map((e) => Channel.fromJson(e))
            .toList(),
      );
}

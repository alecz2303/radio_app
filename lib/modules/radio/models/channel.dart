class Channel {
  final int id;
  final int stationId;
  final String name;
  final String slug;
  final int order;
  final String streamUrl;
  final String? backupUrl;
  final bool isActive;
  final dynamic metadata;

  Channel({
    required this.id,
    required this.stationId,
    required this.name,
    required this.slug,
    required this.order,
    required this.streamUrl,
    this.backupUrl,
    required this.isActive,
    this.metadata,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] ?? 0,
      stationId: json['station_id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      order: json['order'] ?? 0,
      streamUrl: json['stream_url'] ?? '',
      backupUrl: json['backup_url'], // 👈 ya lo tomamos del JSON
      isActive: json['is_active'] ?? true,
      metadata: json['metadata'],
    );
  }
}

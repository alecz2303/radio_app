import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static SharedPreferences? _prefs;
  static const _key = 'favorite_channels';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Set<String> get _set =>
      _prefs?.getStringList(_key)?.toSet() ?? <String>{};

  static bool isFavorite(int stationId, int channelId) {
    return _set.contains('$stationId:$channelId');
  }

  static Future<void> toggleFavorite(int stationId, int channelId) async {
    final key = '$stationId:$channelId';
    final current = _set;
    if (current.contains(key)) {
      current.remove(key);
    } else {
      current.add(key);
    }
    await _prefs?.setStringList(_key, current.toList());
  }
}

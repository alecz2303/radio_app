import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'radio_audio_handler.dart';
import '../modules/radio/models/station.dart';
import '../modules/radio/models/channel.dart';
import '../modules/radio/services/favorites_service.dart';

class RadioPlayerProvider extends ChangeNotifier {
  final AudioHandler _audioHandler;

  Station? currentStation;
  Channel? currentChannel;

  RadioPlayerProvider(this._audioHandler) {
    _audioHandler.playbackState.listen((_) => notifyListeners());
    _initFavorites();
  }

  bool get isPlaying => _audioHandler.playbackState.value.playing;
  bool get hasStation => currentStation != null;

  Future<void> _initFavorites() async {
    await FavoritesService.init();
    notifyListeners();
  }
  
  bool isFavorite(Station station, Channel channel) {
    return FavoritesService.isFavorite(station.id, channel.id);
  }

  Future<void> toggleFavorite(Station station, Channel channel) async {
    await FavoritesService.toggleFavorite(station.id, channel.id);
    notifyListeners();
  }

  Future<void> play(Station station, Channel channel) async {
    currentStation = station;
    currentChannel = channel;

    await (_audioHandler as RadioAudioHandler).playStream(
      url: channel.streamUrl,
      title: channel.name,
      imageUrl: station.logoUrl,
      artist: station.name,
    );
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await _audioHandler.pause();
    } else {
      await _audioHandler.play();
    }
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioHandler.stop();
    currentStation = null;
    currentChannel = null;
    notifyListeners();
  }
}

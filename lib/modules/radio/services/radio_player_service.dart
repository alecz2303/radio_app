
import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class RadioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<PlayerState>? _playerStateSub;

  AudioPlayer get player => _player;

  Future<void> init({
    String? title,
    String? album,
    String? artUri,
    String? url,
  }) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    if (url != null) {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: url,
            title: title ?? 'Radio',
            album: album ?? 'Streaming',
            artUri: artUri != null ? Uri.parse(artUri) : null,
          ),
        ),
      );
    }
  }

  Future<void> setUrl(String url, {String? title, String? album, String? artUri}) async {
    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: url,
          title: title ?? 'Radio',
          album: album ?? 'Streaming',
          artUri: artUri != null ? Uri.parse(artUri) : null,
        ),
      ),
    );
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> dispose() async {
    await _player.dispose();
    await _playerStateSub?.cancel();
  }
}

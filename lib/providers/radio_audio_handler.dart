import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  RadioAudioHandler() {
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;
      playbackState.add(
        PlaybackState(
          controls: [
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.stop,
          ],
          systemActions: const {},
          androidCompactActionIndices: const [0],
          playing: playing,
          processingState: _mapProcessingState(_player.processingState),
          updateTime: DateTime.now(),
        ),
      );
    });
  }

  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  Future<void> playStream({
    required String url,
    required String title,
    required String imageUrl,
    String? artist,
  }) async {
    try {
      await _player.setUrl(url);
      mediaItem.add(
        MediaItem(
          id: url,
          title: title,
          album: artist ?? "La Radio del Diario",
          artUri: Uri.parse(imageUrl),
        ),
      );
      await _player.play();
    } catch (e) {
      debugPrint('❌ Error reproduciendo $url: $e');
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    super.stop();
  }
}

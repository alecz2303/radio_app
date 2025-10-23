import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  RadioAudioHandler() {
    _player.playbackEventStream.listen((event) {
      playbackState.add(
        playbackState.value.copyWith(
          controls: const [
            MediaControl.pause,
            MediaControl.play,
            MediaControl.stop,
          ],
          playing: _player.playing,
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
        ),
      );
    });
  }

  /// Actualiza el MediaItem mostrado en la notificación
  @override
  Future<void> updateMediaItem(MediaItem item) async {
    mediaItem.add(item);
  }

  @override
  Future<void> playMediaItem(MediaItem item) async {
    updateMediaItem(item);
    await _player.setUrl(item.id);
    await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> addQueueItem(MediaItem item) async {
    queue.add([item]);
    updateMediaItem(item);
    await _player.setUrl(item.id);
  }
}

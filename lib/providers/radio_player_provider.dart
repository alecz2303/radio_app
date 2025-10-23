import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../modules/radio/models/station.dart';
import '../modules/radio/models/channel.dart';

class RadioPlayerProvider extends ChangeNotifier {
  final _player = AudioPlayer();
  Station? currentStation;
  Channel? currentChannel;

  bool get isPlaying => _player.playing;
  bool get hasStation => currentStation != null;

  RadioPlayerProvider() {
    // 🔊 Escucha los cambios en el estado del reproductor (play/pause/buffer/etc.)
    _player.playerStateStream.listen((state) {
      debugPrint(
          '🎵 Estado del player: ${state.processingState} | playing=${state.playing}');
      notifyListeners();
    });

    // 🔁 Escucha cambios de fuente de audio (cuando cambia la estación)
    _player.sequenceStateStream.listen((state) {
      final tag = state?.sequence?.isNotEmpty == true
          ? state!.currentSource?.tag
          : null;

      if (tag is MediaItem) {
        debugPrint('📡 MediaItem activo: ${tag.title} (${tag.album})');
      }
    });

    // 🧠 Escucha los eventos de progreso o buffering
    _player.playbackEventStream.listen((event) {
      final position = _player.position;
      debugPrint(
        '📍 Evento: ${event.processingState} | posición=$position',
      );
    });
  }

  /// ▶️ Reproducir una estación y canal específicos
  Future<void> play(Station station, Channel channel) async {
    currentStation = station;
    currentChannel = channel;

    debugPrint('🎧 Iniciando reproducción de: ${station.name} (${channel.name})');
    debugPrint('🔗 URL: ${channel.streamUrl}');
    debugPrint('🖼️ Logo: ${station.logoUrl}');

    try {
      await _player.stop();
      debugPrint('⏹️ Player detenido. Cargando nueva fuente...');

      final source = AudioSource.uri(
        Uri.parse(channel.streamUrl),
        tag: MediaItem(
          id: channel.streamUrl,
          album: station.name,
          title: channel.name,
          artUri: Uri.parse(station.logoUrl),
        ),
      );

      await _player.setAudioSource(source);
      debugPrint('✅ Fuente configurada correctamente.');

      await _player.play();
      debugPrint('▶️ Reproducción iniciada.');
    } catch (e, st) {
      debugPrint('❌ Error al reproducir ${channel.streamUrl}: $e');
      debugPrint(st.toString());
    }
  }

  /// ⏯️ Cambiar entre play y pause
  Future<void> togglePlayPause() async {
    if (_player.playing) {
      debugPrint('⏸️ Pausando reproducción...');
      await _player.pause();
    } else {
      debugPrint('▶️ Reanudando reproducción...');
      await _player.play();
    }
  }

  /// ⏹️ Detener completamente el reproductor
  Future<void> stop() async {
    debugPrint('⛔ Deteniendo player.');
    await _player.stop();
    currentStation = null;
    currentChannel = null;
    notifyListeners();
  }

  @override
  void dispose() {
    debugPrint('🧹 Liberando recursos del player.');
    _player.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_service/audio_service.dart';
import 'providers/radio_player_provider.dart';
import 'modules/news/providers/news_provider.dart';
import 'providers/radio_audio_handler.dart';
import 'modules/radio/pages/radio_stations_page.dart';
import 'pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa el handler de audio
  final audioHandler = await AudioService.init(
    builder: () => RadioAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.radio.diario.channel',
      androidNotificationChannelName: 'Radio en Vivo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

  runApp(MyApp(audioHandler: audioHandler));
}

class MyApp extends StatelessWidget {
  final AudioHandler audioHandler;

  const MyApp({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RadioPlayerProvider(audioHandler),
        ),
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'La Radio del Diario',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const MainPage(),
      ),
    );
  }
}

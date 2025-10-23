import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_bottom_nav.dart';
import 'providers/radio_player_provider.dart';
import 'modules/radio/services/favorites_service.dart';
import 'modules/radio/pages/radio_stations_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesService.init();

  // 🔊 inicializa just_audio_background (esto crea la notificación)
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.radio.laradiodeldiario.channel',
    androidNotificationChannelName: 'La Radio del Diario',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
    androidNotificationIcon: 'mipmap/ic_launcher',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RadioPlayerProvider()),
      ],
      child: const AppRadio(),
    ),
  );
}

class AppRadio extends StatelessWidget {
  const AppRadio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Radio del Diario',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: const RadioStationsPage(),
    );
  }
}

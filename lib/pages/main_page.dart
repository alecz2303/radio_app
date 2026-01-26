import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../modules/radio/pages/radio_stations_page.dart';
import '../modules/news/pages/news_page.dart';
import '../core/widgets/bottom_now_playing_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    RadioStationsPage(),
    NewsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNowPlayingBar(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: const Color(0xFF1E1E1E),
          indicatorColor: Colors.white.withOpacity(0.1),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.radio_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.radio, color: Colors.white),
              label: 'Radio',
            ),
            NavigationDestination(
              icon: Icon(Icons.newspaper_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.newspaper, color: Colors.white),
              label: 'Noticias',
            ),
          ],
        ),
      ),
    );
  }
}

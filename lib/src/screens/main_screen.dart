import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:senewrs/src/screens/home_screen.dart';
import 'package:senewrs/src/screens/saved_news_screen.dart';
import 'package:senewrs/src/screens/settings_screen.dart';
import 'package:senewrs/src/screens/trending_screen.dart';
import 'package:senewrs/src/settings/settings_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.settingsController});

  // Settings Controller for keeping track of device theme
  final SettingsController settingsController;
  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // Current Selected Screen Index
  int _selectedIndex = 0;
  // List of Screens
  late List<Widget> _screenSelector;

  // Makes sure that screen will listen to theme mode changes
  @override
  void initState() {
    super.initState();
    var window = WidgetsBinding.instance!.window;
    window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance?.handlePlatformBrightnessChanged();
      // Forces to update the screen
      setState(
        () {
          _reloadScreens();
        },
      );
    };
    // Initializing screen
    _reloadScreens();
  }

  // Reloads Screen to sync with system theme update
  void _reloadScreens() {
    print("reloaded!");
    _screenSelector = <Widget>[
      // DO NOT PUT KEYWORD "CONST"
      TrendingScreen(),
      HomeScreen(),
      SavedNewsScreen(),
      SettingsScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("building main");
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      // Body changes screen according to selectedIndex
      body: _screenSelector.elementAt(_selectedIndex),
    );
  }

  // Returns the Bottom Navigation Bar Widget
  Widget _buildBottomNavBar() {
    // Easy to change values
    const iconSize = 40.0;
    // Light Mode Colors
    const lightBackgroundColor = Color(0xffD9D9D9);
    const lightSelectedItemColor = Color(0xffFADB41);
    const lightUnselectedItemColor = Colors.black;
    // Dark Mode Colors
    const darkBackgroundColor = Color(0xff353535);
    const darkSelectedItemColor = Color(0xff4662FF);
    const darkUnselectedItemColor = Colors.white;

    return BottomNavigationBar(
      items: const [
        // Trending Icon
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department),
          label: "Trending",
        ),
        // Home Icon
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper),
          label: "Home",
        ),
        // Saved News Icon
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: "Saved News",
        ),
        // Settings Icon
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          _isDarkMode() ? darkBackgroundColor : lightBackgroundColor,
      selectedItemColor:
          _isDarkMode() ? darkSelectedItemColor : lightSelectedItemColor,
      unselectedItemColor:
          _isDarkMode() ? darkUnselectedItemColor : lightUnselectedItemColor,
      currentIndex: _selectedIndex,
      iconSize: iconSize,
      onTap: (index) => setState(() => _selectedIndex = index),
    );
  }

  // Returns True if dark mode is enabled; used in changing UI colors
  bool _isDarkMode() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }
}

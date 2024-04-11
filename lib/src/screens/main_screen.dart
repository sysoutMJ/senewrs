/* 
  Main Screen of the App
*/

import 'package:flutter/material.dart';
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
  late List<Widget> _appScreens;

  // Makes sure that screen will listen to system theme mode changes
  // TO BE REMOVED
  @override
  void initState() {
    super.initState();
    // Initializing screen
    _reloadScreens();
  }

  // Reloads Screen to sync with app theme update
  void _reloadScreens() {
    _appScreens = <Widget>[
      TrendingScreen(settingsController: widget.settingsController),
      HomeScreen(settingsController: widget.settingsController),
      SavedNewsScreen(settingsController: widget.settingsController),
      SettingsScreen(settingsController: widget.settingsController)
    ];
    print("reloaded!");
  }

  @override
  Widget build(BuildContext context) {
    // rebuildAllChildren(context);
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      // Body changes screen according to selectedIndex
      body: IndexedStack(
        index: _selectedIndex,
        children: _appScreens,
      ),
    );
  }

  // Returns the Bottom Navigation Bar Widget
  Widget _buildBottomNavBar() {
    // Easy to change values
    const iconSize = 40.0;

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
      currentIndex: _selectedIndex,
      iconSize: iconSize,
      onTap: (index) => setState(() => _selectedIndex = index),
    );
  }
}

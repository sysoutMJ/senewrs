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

  // Keys for maintaining state?
  final _trendingScreen = GlobalKey<NavigatorState>();
  final _homeScreen = GlobalKey<NavigatorState>();
  final _savedNewsScreen = GlobalKey<NavigatorState>();
  final _settingsScreen = GlobalKey<NavigatorState>();

  late final _navScreens;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Initializing navigation screens; to prevent it from being frequently reloading
    _navScreens = <Widget>[
      Navigator(
        key: _trendingScreen,
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) =>
              TrendingScreen(settingsController: widget.settingsController),
        ),
      ),
      Navigator(
        key: _homeScreen,
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) =>
              HomeScreen(settingsController: widget.settingsController),
        ),
      ),
      Navigator(
        key: _savedNewsScreen,
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) =>
              SavedNewsScreen(settingsController: widget.settingsController),
        ),
      ),
      Navigator(
        key: _settingsScreen,
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) =>
              SettingsScreen(settingsController: widget.settingsController),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    // rebuildAllChildren(context);
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      // Helps to prevent app from crashing when using back button in homescreen
      body: WillPopScope(
        onWillPop: () async {
          return !await _homeScreen.currentState!.maybePop();
        },
        // Body changes screen according to selectedIndex
        child: IndexedStack(
          index: _selectedIndex,
          children: _navScreens,
        ),
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
      onTap: (index) => _onTap(index, context),
    );
  }

  // Allows to go back by tapping the same bottom nav bar icon again
  void _onTap(int val, BuildContext context) {
    if (_selectedIndex == val) {
      switch (val) {
        case 0:
          _trendingScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case 1:
          _homeScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case 2:
          _savedNewsScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        case 3:
          _settingsScreen.currentState?.popUntil((route) => route.isFirst);
          break;
        default:
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedIndex = val;
        });
      }
    }
  }
}

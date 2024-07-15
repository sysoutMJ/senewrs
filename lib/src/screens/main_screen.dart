/* 
  Main Screen of the App
*/

import 'package:flutter/material.dart';
import 'package:senewrs/src/screens/home_screen.dart';
import 'package:senewrs/src/screens/news_screen.dart';
import 'package:senewrs/src/screens/saved_news_screen.dart';
import 'package:senewrs/src/screens/settings_screen.dart';

import 'package:senewrs/src/settings/settings_controller.dart';

import '../settings/settings_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.settingsController});

  // Settings Controller for keeping track of device theme
  final SettingsController settingsController;
  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // Current Selected Screen Index
  int _selectedIndex = 1;

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
          builder: (context) => NewsScreen(
            settingsController: widget.settingsController,
            category: "Trending",
            httpQuery:
                "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&categories=general&languages=en&limit=100&sources=bbc,cnn,nbc",
            hasBackButton: false,
            hasSearchWidget: true,
          ),
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
          // Makes sure back button will work on other screens
          switch (_selectedIndex) {
            case 0:
              return !await _trendingScreen.currentState!.maybePop();
            case 1:
              return !await _homeScreen.currentState!.maybePop();
            case 2:
              return !await _savedNewsScreen.currentState!.maybePop();
            case 3:
              return !await _settingsScreen.currentState!.maybePop();
            default:
              throw Exception("Defaulted on home_screen");
          }
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
      items: [
        // Trending Icon
        BottomNavigationBarItem(
          icon: SettingsService.isDarkMode(widget.settingsController.themeMode)
              ? Image.asset('assets/not-selected-default-icons/dark-default-trending-icon.png')
              : Image.asset('assets/not-selected-default-icons/light-default-trending-icon.png'),
          activeIcon: SettingsService.isDarkMode(widget.settingsController.themeMode)
              ? Image.asset('assets/when-selected-icons/dark-trending-selected-icon.png')
              : Image.asset('assets/when-selected-icons/light-trending-selected-icon.png'),
          label: "Trending",
        ),
        // Home Icon
        BottomNavigationBarItem(
          icon: SettingsService.isDarkMode(widget.settingsController.themeMode)
              ? Image.asset('assets/not-selected-default-icons/dark-default-home-icon.png')
              : Image.asset('assets/not-selected-default-icons/light-default-home-icon.png'),
          activeIcon: SettingsService.isDarkMode(widget.settingsController.themeMode)
              ? Image.asset('assets/when-selected-icons/dark-home-selected-icon.png')
              : Image.asset('assets/when-selected-icons/light-home-selected-icon.png'),
          label: "Home",
        ),
        // Saved News Icon
        BottomNavigationBarItem(
          icon: SettingsService.isDarkMode(widget.settingsController.themeMode)
              ? Image.asset('assets/not-selected-default-icons/dark-default-saved-news-icon.png')
              : Image.asset('assets/not-selected-default-icons/light-default-saved-news-icon.png'),
          activeIcon: SettingsService.isDarkMode(widget.settingsController.themeMode)
              ? Image.asset('assets/when-selected-icons/dark-saved-news-selected-icon.png')
              : Image.asset('assets/when-selected-icons/light-saved-news-selected-icon.png'),
          label: "Saved News",
        ),
        // Settings Icon
        BottomNavigationBarItem(
          icon: SettingsService.isDarkMode(widget.settingsController.themeMode)
              ? Image.asset('assets/not-selected-default-icons/dark-default-setting-icon.png')
              : Image.asset('assets/not-selected-default-icons/light-default-setting-icon.png'),
          activeIcon: SettingsService.isDarkMode(widget.settingsController.themeMode)
              ? Image.asset('assets/when-selected-icons/dark-settings-selected-icon.png')
              : Image.asset('assets/when-selected-icons/light-settings-selected-icon.png'),
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

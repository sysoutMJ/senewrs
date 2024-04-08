import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Easy to change values
  final senewrsLogoDark =
      const AssetImage("assets/images/senewrs_logo_dark.png");
  final senewrsLogoLight =
      const AssetImage("assets/images/senewrs_logo_light.png");

  @override
  Widget build(BuildContext context) {
    print("building homescreen");
    return SingleChildScrollView(
      child: Column(
        children: [
          Image(image: _isDarkMode() ? senewrsLogoLight : senewrsLogoDark)
        ],
      ),
    );
  }

  // Returns True if dark mode is enabled; used in changing UI colors
  bool _isDarkMode() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }
}

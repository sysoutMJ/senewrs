import 'package:flutter/material.dart';
import 'package:senewrs/src/settings/settings_controller.dart';
import 'package:senewrs/src/settings/settings_service.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key, required this.settingsController});

  // Retrieving Settings Controller to change system themes
  final SettingsController settingsController;
  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  // Easy to change values
  final senewrsLogoDark =
      const AssetImage("assets/images/senewrs_logo_dark.png");
  final senewrsLogoLight =
      const AssetImage("assets/images/senewrs_logo_light.png");

  @override
  Widget build(BuildContext context) {
    print("building trendingscreen");
    return SingleChildScrollView(
      child: Column(
        children: _test(),
      ),
    );
  }

  List<Widget> _test() {
    List<Widget> myList = [];
    for (var i = 0; i < 15; i++) {
      myList.add(
        Image(
            image:
                SettingsService.isDarkMode(widget.settingsController.themeMode)
                    ? senewrsLogoDark
                    : senewrsLogoLight),
      );
      myList.add(Text(i.toString()));
    }
    return myList;
  }
}

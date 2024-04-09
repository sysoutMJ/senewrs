import 'package:flutter/material.dart';
import 'package:senewrs/src/helpers/settings_helper.dart';
import 'package:senewrs/src/settings/settings_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.settingsController});

  // Retrieving Settings Controller to change system themes
  final SettingsController settingsController;
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
        children: _test(),
      ),
    );
  }

  List<Widget> _test() {
    List<Widget> myList = [];
    for (var i = 0; i < 15; i++) {
      myList.add(Image(
          image: SettingsHelper.isDarkMode(widget.settingsController.themeMode)
              ? senewrsLogoLight
              : senewrsLogoDark));
      myList.add(Text(i.toString()));
    }
    return myList;
  }
}

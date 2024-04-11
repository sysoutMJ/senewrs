import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senewrs/src/settings/settings_controller.dart';
import 'package:senewrs/src/settings/settings_service.dart';

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

  final _appNameStyle = GoogleFonts.robotoSerif(
    textStyle: const TextStyle(fontSize: 50),
  );

  @override
  Widget build(BuildContext context) {
    print("building homescreen");
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return SingleChildScrollView(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                decoration: BoxDecoration(color: Colors.amber),
                child: Column(
                  children: [
                    // Senewrs Logo
                    Image(
                        image: SettingsService.isDarkMode(
                                widget.settingsController.themeMode)
                            ? senewrsLogoLight
                            : senewrsLogoDark),
                    // App Name
                    Text(
                      "SENEWRS",
                      style: _appNameStyle,
                    ),
                    _buildSearchWidget()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Builds the search widget
  Widget _buildSearchWidget() {
    return Row(
      children: [
        // Text Field
        Flexible(
          child: TextField(
            decoration: InputDecoration(
                hintText: "Search",
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: SettingsService.isDarkMode(
                        widget.settingsController.themeMode)
                    ? const Color(0xff1C1C1C)
                    : Colors.white),
          ),
        ),
        FilledButton(
          onPressed: () => print("searching..."),
          style: FilledButton.styleFrom(
            minimumSize: const Size(50, 64),
            shape: const ContinuousRectangleBorder(),
            backgroundColor: Colors.black,
          ),
          child: const Icon(
            Icons.search,
          ),
        )
      ],
    );
  }
}

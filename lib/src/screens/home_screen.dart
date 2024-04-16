import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senewrs/src/screens/news_screen.dart';
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
  // RESTART CODE TO SEE CHANGES
  final _senewrsLogoDark =
      const AssetImage("assets/images/senewrs_logo_dark.png");
  final _senewrsLogoLight =
      const AssetImage("assets/images/senewrs_logo_light.png");
  final _appNameStyle = GoogleFonts.robotoSerif(
    textStyle: const TextStyle(fontSize: 50),
  );
  final double _newsButtonBorderRadius = 5;
  final double _newsButtonHeight = 80;
  final double _newsButtonWidth = 170;
  final double _newsButtonTopPadding = 20;
  final double _newsButtonFontSize = 30;

  @override
  Widget build(BuildContext context) {
    print("building homescreen");
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return ListenableBuilder(
              listenable: widget.settingsController,
              builder: (BuildContext context, Widget? child) {
                return SingleChildScrollView(
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.amber),
                        child: Column(
                          children: [
                            // Senewrs Logo
                            Image(
                                image: SettingsService.isDarkMode(
                                        widget.settingsController.themeMode)
                                    ? _senewrsLogoLight
                                    : _senewrsLogoDark),
                            // App Name
                            Text(
                              "SENEWRS",
                              style: _appNameStyle,
                            ),
                            // Search Widget
                            _buildSearchWidget(),
                            // Space between news Buttons and Search widgets
                            SizedBox(height: 20),
                            // News Buttons
                            _buildNewsButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
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
            minimumSize: const Size(30, 64),
            shape: const ContinuousRectangleBorder(),
            backgroundColor: Colors.black,
          ),
          child: const Icon(
            Icons.search,
            size: 40,
          ),
        )
      ],
    );
  }

  // Builds clickable News Category Buttons
  Widget _buildNewsButtons() {
    // List of categories
    final categories = [
      "General",
      "Business",
      "Entertainment",
      "Health",
      "Science",
      "Sports",
      "Techonology"
    ];
    List<Row> buttonRows = [];
    Padding buttonPair = const Padding(
      padding: EdgeInsets.zero,
    );

    // Iterating through categories starting at 1
    for (var i = 1; i <= categories.length; i++) {
      // For every 2nd category
      if (i % 2 == 0) {
        // Add row to list of rows
        buttonRows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [buttonPair, _createNewsButton(categories[i - 1])],
          ),
        );
        // If adding last button that is not even
      } else if (i == categories.length) {
        buttonRows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_createNewsButton(categories[i - 1])],
          ),
        );
      }
      // Else
      buttonPair = _createNewsButton(categories[i - 1]);
    }

    // Return Column Spreading rows
    return Column(
      children: [...buttonRows],
    );
  }

  // Returns to build Eleveted News Button; to avoid redundant code
  Padding _createNewsButton(String category) {
    return Padding(
      padding: EdgeInsets.only(top: _newsButtonTopPadding),
      child: SizedBox(
        height: _newsButtonHeight,
        width: _newsButtonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(_newsButtonBorderRadius),
              ),
            ),
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => NewsScreen(),
            ),
          ),
          child: Text(
            category,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: _newsButtonFontSize),
          ),
        ),
      ),
    );
  }
}

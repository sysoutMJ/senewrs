  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'package:senewrs/src/screens/news_screen.dart';
  import 'package:senewrs/src/settings/settings_controller.dart';
  import 'package:senewrs/src/settings/settings_service.dart';
  import 'package:senewrs/src/widgets/search_widget.dart';

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
      return ListenableBuilder(
        listenable: widget.settingsController,
        builder: (BuildContext context, Widget? child) {
          return SingleChildScrollView(
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
                  margin: const EdgeInsetsDirectional.fromSTEB(0, 80, 0, 0),
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

                      // Custom Search Widget
                      SearchWidget(
                        settingsController: widget.settingsController,
                      ),

                      // Space between news Buttons and Search widgets
                      const SizedBox(height: 0),
                      // News Buttons
                      _buildNewsButtons(),
                    ],
                  ),
                )
              ),
            ),
          );
        },
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
        "Technology"
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
        child: Container(
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color(0xff555555),
                    blurRadius: 8,
                    spreadRadius: -3,
                    offset: Offset(0, 5)
                ),
              ]
          ),
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
              onPressed: () => _fetchNewsCategory(category),
              child: Text(
                category,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: _newsButtonFontSize),
              ),
            ),
          ),
        )
      );
    }

    void _fetchNewsCategory(String category) {
      print(category);
      String _categoryHttpQuery = "";

      // Change query according to query
      switch (category) {
        case "General":
          _categoryHttpQuery =
              "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&categories=general&languages=en&limit=100";
          break;
        case "Business":
          _categoryHttpQuery =
              "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&categories=business&languages=en&limit=100";
          break;
        case "Entertainment":
          _categoryHttpQuery =
              "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&categories=entertainment&languages=en&limit=100";
          break;
        case "Health":
          _categoryHttpQuery =
              "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&categories=health&languages=en&limit=100";
          break;
        case "Science":
          _categoryHttpQuery =
              "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&categories=science&languages=en&limit=100";
          break;
        case "Sports":
          _categoryHttpQuery =
              "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&categories=sports&languages=en&limit=100";
          break;
        case "Technology":
          _categoryHttpQuery =
              "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&categories=technology&languages=en&limit=100";
          break;
        default:
      }

      // Push to category page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => NewsScreen(
            settingsController: widget.settingsController,
            category: category,
            httpQuery: _categoryHttpQuery,
            hasBackButton: true,
            hasSearchWidget: true,
          ),
        ),
      );
    }
  }

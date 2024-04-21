/*
  News Container Widget
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senewrs/src/models/news.dart';
import 'package:senewrs/src/screens/detailed_news_screen.dart';
import 'package:senewrs/src/settings/settings_service.dart';

class NewsContainer extends StatefulWidget {
  const NewsContainer(
      {super.key, required this.settingsController, required this.newsItem});

  final settingsController;
  final News newsItem;

  @override
  State<NewsContainer> createState() => _NewsContainerState();
}

class _NewsContainerState extends State<NewsContainer> {
  // Easy to change values
  final _lightModeContainerColor = const Color(0xffD9D9D9);
  final _darkModeContainerColor = const Color(0xff555555);

  // Variable that will change bookmark icon
  var _wasSaved = false;

  // returns true if news is saved
  bool _isNotSaved() {
    if (_wasSaved == true) {
      return false;
    }
    return true;
  }

  // Saves news
  void _saveNews() {
    setState(() => _wasSaved = !_wasSaved);
    // CODE TO SAVE NEWS TO JSON
    print("saving news...");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Successfully saved news!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Easy to change values
    var newsTitleFontStyle = GoogleFonts.robotoSerif(
      textStyle: TextStyle(
          fontSize: widget.settingsController.fontSize * 0.6,
          fontWeight: FontWeight.bold),
    );
    var otherTextFontStyle = GoogleFonts.robotoSlab(
      textStyle: TextStyle(fontSize: widget.settingsController.fontSize * 0.6),
    );
    // 50% of system Font Size
    var iconSize = widget.settingsController.fontSize;

    // Used to capture user tap on container
    return GestureDetector(
      // On tap, navigate to detailed news screen
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            // Makes sure to be able to listen to settings changes
            return ListenableBuilder(
              listenable: widget.settingsController,
              builder: (BuildContext context, Widget? child) =>
                  DetailedNewsScreen(
                      settingsController: widget.settingsController,
                      newsItem: widget.newsItem),
            );
          },
        ),
      ),
      child: Container(
        // Set background color of container
        decoration: BoxDecoration(
            color:
                SettingsService.isDarkMode(widget.settingsController.themeMode)
                    ? _darkModeContainerColor
                    : _lightModeContainerColor),
        // Used to determine max width size of container
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              CachedNetworkImage(
                fit: BoxFit.cover,
                width: constraints.maxWidth,
                height: 150,
                imageUrl: widget.newsItem.imgLink,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                // Returning App Logo if failed to load imagee
                errorWidget: (context, url, error) {
                  if (SettingsService.isDarkMode(
                      widget.settingsController.themeMode)) {
                    return const Image(
                      image: AssetImage("assets/images/senewrs_logo_light.png"),
                    );
                  } else {
                    return const Image(
                      image: AssetImage("assets/images/senewrs_logo_dark.png"),
                    );
                  }
                },
              ),
              // News Title
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: constraints.maxWidth * 0.035,
                  right: constraints.maxWidth * 0.035,
                ),
                child: Text(
                  widget.newsItem.newsTitle,
                  style: newsTitleFontStyle,
                ),
              ),
              // Date, News Publisher
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: constraints.maxWidth * 0.035,
                  right: constraints.maxWidth * 0.035,
                ),
                // Widget that prevents overflow when size is increased
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Publisher
                    Text(
                      widget.newsItem.source,
                      style: otherTextFontStyle,
                    ),
                    // Bookmark icon
                    IconButton(
                      onPressed: _isNotSaved() ? _saveNews : null,
                      icon: _wasSaved
                          ? const Icon(Icons.bookmark_added)
                          : const Icon(Icons.bookmark_add_outlined),
                      iconSize: iconSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

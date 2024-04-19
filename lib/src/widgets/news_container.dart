/*
  News Container Widget
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senewrs/src/models/news.dart';
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

  @override
  Widget build(BuildContext context) {
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              // News Title
              Padding(
                padding: EdgeInsets.only(
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
                  left: constraints.maxWidth * 0.035,
                  right: constraints.maxWidth * 0.035,
                ),
                child: Row(
                  children: [
                    // Date
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.newsItem.datePublished,
                        style: otherTextFontStyle,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          // Publisher
                          Text(
                            widget.newsItem.source,
                            style: otherTextFontStyle,
                          ),
                          // Bookmark icon
                          IconButton(
                              onPressed: () =>
                                  setState(() => _wasSaved = !_wasSaved),
                              icon: _wasSaved
                                  ? const Icon(Icons.bookmark_added)
                                  : const Icon(Icons.bookmark_add_outlined),
                              iconSize: iconSize),
                        ],
                      ),
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

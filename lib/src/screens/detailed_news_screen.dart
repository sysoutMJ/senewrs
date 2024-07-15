import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senewrs/src/models/news.dart';
import 'package:senewrs/src/settings/settings_controller.dart';
import 'package:senewrs/src/settings/settings_service.dart';

class DetailedNewsScreen extends StatefulWidget {
  const DetailedNewsScreen(
      {super.key, required this.newsItem, required this.settingsController});

  final News newsItem;
  final SettingsController settingsController;

  @override
  State<DetailedNewsScreen> createState() => _DetailedNewsScreenState();
}

class _DetailedNewsScreenState extends State<DetailedNewsScreen> {
  // Easy to change values
  double _widgetTopPadding = 10;
  double _widgetSidePadding = 20;

  @override
  Widget build(BuildContext context) {
    // Easy to change values
    var newsTitleStyle = GoogleFonts.robotoSerif(
      textStyle: TextStyle(
          fontSize: widget.settingsController.fontSize + 15,
          fontWeight: FontWeight.bold),
    );
    var newsSourceStyle = GoogleFonts.robotoSlab(
      textStyle: TextStyle(fontSize: widget.settingsController.fontSize * 0.6),
    );
    var newsSourceNameStyle = GoogleFonts.robotoSlab(
      textStyle: TextStyle(
        fontSize: widget.settingsController.fontSize * 0.6,
        fontWeight: FontWeight.bold,
      ),
    );
    var newsDescStyle = GoogleFonts.roboto(
      textStyle: TextStyle(fontSize: widget.settingsController.fontSize),
    );

    // Makes sure to be able to adapt to notches
    return SafeArea(
      child: SingleChildScrollView(
        child: 
          Container(
            margin: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: SettingsService.isDarkMode(widget.settingsController.themeMode)
                      ? Image.asset('assets/images/light-mode-back-button.png')
                      : Image.asset('assets/images/dark-mode-back-button.png'),
                ),
                // News Title
                Padding(
                  padding: EdgeInsets.only(
                      top: _widgetTopPadding,
                      bottom: _widgetTopPadding,
                      left: _widgetSidePadding,
                      right: _widgetSidePadding),
                  child: Text(
                    widget.newsItem.newsTitle,
                    style: newsTitleStyle,
                  ),
                ),
                // News Image; Layout Builder used to make sure occupying max width
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // If there is image link
                    if (widget.newsItem.imgLink != "image") {
                      return CachedNetworkImage(
                        imageUrl: widget.newsItem.imgLink,
                        width: constraints.maxWidth,
                        height: 200,
                        fit: BoxFit.cover,
                      );
                      // Else, return logo
                    } else {
                      return Center(
                        child: Image(
                          height: 200,
                          image: SettingsService.isDarkMode(
                              widget.settingsController.themeMode)
                              ? const AssetImage(
                              "assets/images/senewrs_logo_light.png")
                              : const AssetImage(
                              "assets/images/senewrs_logo_dark.png"),
                        ),
                      );
                    }
                  },
                ),

                // Row for Source
                Padding(
                  padding: EdgeInsets.only(
                    top: _widgetTopPadding,
                    left: _widgetSidePadding,
                    right: _widgetSidePadding,
                  ),
                  child: Wrap(
                    children: [
                      Text(
                        "By ",
                        style: newsSourceStyle,
                      ),
                      Text(
                        widget.newsItem.source,
                        style: newsSourceNameStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _widgetTopPadding,
                      left: _widgetSidePadding,
                      right: _widgetSidePadding),
                  child: Text(
                    widget.newsItem.description,
                    style: newsDescStyle,
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}

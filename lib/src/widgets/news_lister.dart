/*
  Widget that displays all news in passed list of news
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senewrs/src/helpers/saved_news_manager.dart';
import 'package:senewrs/src/models/news.dart';
import 'package:senewrs/src/settings/settings_controller.dart';
import 'package:senewrs/src/widgets/news_container.dart';
import 'package:senewrs/src/widgets/search_widget.dart';

import '../settings/settings_service.dart';

class NewsLister extends StatefulWidget {
  const NewsLister({
    super.key,
    required this.settingsController,
    required this.category,
    required this.newsList,
    required this.hasBackButton,
    required this.hasSearchWidget,
  });

  final SettingsController settingsController;
  final String category;
  final List<News> newsList;
  final bool hasBackButton, hasSearchWidget;

  @override
  State<NewsLister> createState() => _NewsListerState();
}

class _NewsListerState extends State<NewsLister> {
  @override
  Widget build(BuildContext context) {
    // Used to automatically rebuild widget on change on Settings Controller
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        // Sets Max size to 80% of screen
        return FractionallySizedBox(
          widthFactor: 0.8,
          child: SafeArea(
            child: Column(
              children: [
                // Category text
                _buildHeader(),
                // Search
                _buildSearchWidget(),
                // News List
                _buildNewsList(),
              ],
            ),
          ),
        );
      },
    );
  }

  // Returns the header
  Widget _buildHeader() {
    // Easy to change value
    var categoryTextTextStyle = GoogleFonts.ptSerifCaption(
      textStyle: TextStyle(
        fontSize: widget.settingsController.fontSize + 30,
        fontWeight: FontWeight.bold,
      ),
    );

    if (widget.hasBackButton) {
      return Container(
        margin: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
        child: Row(
          children: [
            IconButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              icon: SettingsService.isDarkMode(widget.settingsController.themeMode)
                  ? Image.asset('assets/images/light-mode-back-button.png')
                  : Image.asset('assets/images/dark-mode-back-button.png'),
            ),
            Flexible(
              child: Text(
                widget.category,
                style: categoryTextTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else {
      return Text(widget.category,
          style: categoryTextTextStyle, overflow: TextOverflow.ellipsis);
    }
  }

  // Returns Search Widget
  Widget _buildSearchWidget() {
    // Return search widget hasSearchWidget is true
    if (widget.hasSearchWidget) {
      return SearchWidget(settingsController: widget.settingsController);
    }
    // Return empty container if has no search widget
    return Container();
  }

  // Returns scrollable list of news
  Widget _buildNewsList() {
    // If there is no news found
    if (widget.newsList.isEmpty) {
      return const Center(child: Text("No News Found."));
    }

    // Else
    // Scrollable View; wraped in expanded to enable sticky header
    return Expanded(
      child: ListView.separated(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.newsList.length,
        // Builder for the separator
        separatorBuilder: (context, int index) => const SizedBox(
          height: 20,
          width: 10,
        ),
        // Builder for News Container
        itemBuilder: (context, int index) {
          // Getting Saved News Manager instance to keep track of saved news
          var savedNewsManager =
              SavedNewsManager(settingsController: widget.settingsController);
          var isAlreadySaved = false;

          // Iterating through all saved news
          for (News savedNews in savedNewsManager.savedNews) {
            // If current news is in saved news, then set to true
            if (widget.newsList[index].url == savedNews.url) {
              isAlreadySaved = true;
            }
          }

          // Return container
          return NewsContainer(
            isAlreadySaved: isAlreadySaved,
            settingsController: widget.settingsController,
            newsItem: widget.newsList[index],
          );
        },
      ),
    );
  }
}

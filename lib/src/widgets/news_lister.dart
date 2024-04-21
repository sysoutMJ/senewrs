/*
  Widget that displays all news in passed list of news
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:senewrs/src/models/news.dart';
import 'package:senewrs/src/settings/settings_controller.dart';
import 'package:senewrs/src/widgets/news_container.dart';
import 'package:senewrs/src/widgets/search_widget.dart';

class NewsLister extends StatefulWidget {
  const NewsLister({
    super.key,
    required this.settingsController,
    required this.category,
    required this.newsList,
    required this.hasBackButton,
  });

  final SettingsController settingsController;
  final String category;
  final List<News> newsList;
  final bool hasBackButton;

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
            child: _buildBody(),
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          Flexible(
            child: Text(
              widget.category,
              style: categoryTextTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      return Text(
        widget.category,
        style: categoryTextTextStyle,
      );
    }
  }

  // Returns the body of the page
  Widget _buildBody() {
    // Return this column if there is no news retrieved
    if (widget.newsList.isEmpty) {
      return Column(
        children: [
          // Category text
          _buildHeader(),
          // Search
          SearchWidget(settingsController: widget.settingsController),
          const Center(
            child: Text("No News Found."),
          ),
        ],
      );
    }

    // Returns this column if there is news retrieved
    return Column(
      children: [
        // Category text
        _buildHeader(),
        // Search
        SearchWidget(settingsController: widget.settingsController),
        // Scrollable View; wraped in expanded to enable sticky header
        Expanded(
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
              return NewsContainer(
                settingsController: widget.settingsController,
                newsItem: widget.newsList[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

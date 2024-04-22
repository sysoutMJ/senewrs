/*
  Displays News Screen results from search or click on news category
 */
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:senewrs/src/models/news.dart';
import 'package:senewrs/src/settings/settings_controller.dart';
import 'package:senewrs/src/widgets/news_lister.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen(
      {super.key,
      required this.settingsController,
      required this.category,
      required this.httpQuery,
      required this.hasBackButton,
      required this.hasSearchWidget});

  final SettingsController settingsController;
  final String category;
  final String httpQuery;
  final bool hasBackButton, hasSearchWidget;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late final Future<Map> retrievedNews;

// Retrieves trending news from API
  Future<Map> getNews() async {
    Map<String, dynamic> newsItems;
    final response = await http.get(
      Uri.parse(widget.httpQuery),
    );

    // If successful
    if (response.statusCode == 200) {
      // Converting response as Map
      newsItems = jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Error");
    }
    return newsItems;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrievedNews = getNews();
  }

  @override
  Widget build(BuildContext context) {
    // Builder that handles Future Variables
    return FutureBuilder(
      future: retrievedNews,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          // While still loading
          case ConnectionState.waiting:
            // Show Loading Screen
            return const CircularProgressIndicator();
          // When successfully retrieved
          case ConnectionState.done:
            // Initialize List
            List<News> newsList = List.empty(growable: true);
            // For each news in data in Map
            for (var newsItem in snapshot.data!["data"]) {
              // Add News Object to News List
              newsList.add(
                News.fromJson(newsItem),
              );
            }
            // Widget that displays all news in list
            return NewsLister(
              settingsController: widget.settingsController,
              category: widget.category,
              newsList: newsList,
              hasBackButton: widget.hasBackButton,
              hasSearchWidget: widget.hasSearchWidget,
            );
          default:
            return const Text("defaulted");
        }
      },
    );
  }
}

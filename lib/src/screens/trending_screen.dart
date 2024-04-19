import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:senewrs/src/models/news.dart';
import 'package:senewrs/src/settings/settings_controller.dart';
import 'package:senewrs/src/widgets/news_container.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key, required this.settingsController});

  // Retrieving Settings Controller to change system themes
  final SettingsController settingsController;
  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  // Easy to change values
  final senewrsLogoDark =
      const AssetImage("assets/images/senewrs_logo_dark.png");
  final senewrsLogoLight =
      const AssetImage("assets/images/senewrs_logo_light.png");
  final httpQuery =
      "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&categories=general,-business&languages=en";
  late final Future<Map> trendingNews;

  // Retrieving news from API
  @override
  void initState() {
    super.initState();
    trendingNews = getTrendingNews();
  }

  // Retrieves trending news from API
  Future<Map> getTrendingNews() async {
    Map<String, dynamic> newsItems;
    final response = await http.get(
      Uri.parse(httpQuery),
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
  Widget build(BuildContext context) {
    print("building trendingscreen");
    // Builder that handles Future Variables
    return FutureBuilder(
      future: trendingNews,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          // While still loading
          case ConnectionState.waiting:
            // Show Loading Screen
            return const CircularProgressIndicator();
          // When successfully retrieved
          case ConnectionState.done:
            // Initialize List
            List<News> trendingNews = List.empty(growable: true);
            // For each news in data in Map
            for (var newsItem in snapshot.data!["data"]) {
              // Add News Object to News List
              trendingNews.add(
                News.fromJson(newsItem),
              );
            }
            // Used to automatically rebuild widget on change on Settings Controller
            return ListenableBuilder(
              listenable: widget.settingsController,
              builder: (BuildContext context, Widget? child) {
                // Sets Max size to 80% of screen
                return FractionallySizedBox(
                  widthFactor: 0.8,
                  // Building a widget for each item in the list
                  child: ListView.separated(
                    itemCount: trendingNews.length,
                    // Builder for the separator
                    separatorBuilder: (context, int index) => const SizedBox(
                      height: 20,
                      width: 10,
                    ),
                    // Builder for News Container
                    itemBuilder: (context, int index) {
                      print(trendingNews[index].imgLink);
                      return NewsContainer(
                        settingsController: widget.settingsController,
                        newsItem: trendingNews[index],
                      );
                    },
                  ),
                );
              },
            );
          default:
            return Text("defaulted");
        }
      },
    );
  }
}

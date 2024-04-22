import 'dart:convert';
import 'package:senewrs/src/models/news.dart';
import 'package:senewrs/src/settings/settings_controller.dart';

class SavedNewsManager {
  SavedNewsManager({required this.settingsController}) {
    getSavedNews();
  }

  final SettingsController settingsController;

  List<News> savedNews = List.empty(growable: true);

  // Retrieves saved news from storage
  Future<void> getSavedNews() async {
    List<News> listOfNews = List.empty(growable: true);

    // For each news item in retrieved saved news
    for (var newsItem in jsonDecode(settingsController.savedNews)) {
      // Create News object then add to list of news
      listOfNews.add(
        News(
          newsTitle: newsItem["newsTitle"],
          description: newsItem["description"],
          author: newsItem["author"],
          source: newsItem["source"],
          imgLink: newsItem["imgLink"],
          url: newsItem["url"],
          datePublished: newsItem["datePublished"],
        ),
      );
    }
    savedNews = listOfNews;
  }

  // Saves saved news from storage
  Future<bool> saveSavedNews(News newsItem) async {
    // Retrieving current list of news
    List<News> listOfNews = savedNews;

    // For each news in list of news
    for (var news in listOfNews) {
      // Returns false if news is already saved on saved news
      if (news.url == newsItem.url) {
        return false;
      }
    }

    // Add news to saved news
    listOfNews.add(newsItem);
    // Make list to string
    String stringNews = jsonEncode(listOfNews);
    // Saving to storage
    settingsController.saveSavedNews(stringNews);
    // Updating news list
    await settingsController.getSavedNews();
    // Returns true to indicate successful saving
    return true;
  }
}

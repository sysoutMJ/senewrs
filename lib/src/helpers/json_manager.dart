import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:senewrs/src/models/news.dart';

class JSONManager {
  Future<Map> readSavedNews() async {
    String response = "";
    try {
      response = await rootBundle.loadString('assets/saved_news.json');
    } catch (e) {
      print(e);
    }
// Returning read JSON Data
    return jsonDecode(response);
  }

  Future<File> saveSavedNews(List<News> listOfNews) async {
    final file = await File('assets/saved_news.json');
    return file.writeAsString(jsonEncode(listOfNews));
  }
}

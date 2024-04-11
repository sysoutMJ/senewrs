/*
  Screen that displays all of the fetched news from API
*/

import 'package:flutter/material.dart';
import 'package:senewrs/src/settings/settings_controller.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({super.key, required this.settingsController});

  final SettingsController settingsController;
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return Center(
          child: Text("News Screen"),
        );
      },
    );
  }
}

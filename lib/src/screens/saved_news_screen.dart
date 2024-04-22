import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:senewrs/src/helpers/saved_news_manager.dart';
import 'package:senewrs/src/settings/settings_controller.dart';
import 'package:senewrs/src/widgets/news_lister.dart';

class SavedNewsScreen extends StatefulWidget {
  const SavedNewsScreen({super.key, required this.settingsController});

  // Retrieving Settings Controller to change system themes
  final SettingsController settingsController;
  @override
  State<SavedNewsScreen> createState() => _SavedNewsScreenState();
}

class _SavedNewsScreenState extends State<SavedNewsScreen> {
  late SavedNewsManager mySavedNewsManager;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        // Reinstantiating news
        mySavedNewsManager =
            SavedNewsManager(settingsController: widget.settingsController);
        return SafeArea(
          child: NewsLister(
            settingsController: widget.settingsController,
            category: "Saved News",
            newsList: mySavedNewsManager.savedNews,
            hasBackButton: false,
            hasSearchWidget: false,
          ),
        );
      },
    );
  }
}

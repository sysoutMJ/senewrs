import 'package:flutter/material.dart';
import 'package:senewrs/src/settings/settings_controller.dart';

class SavedNewsScreen extends StatefulWidget {
  const SavedNewsScreen({super.key, required this.settingsController});

  // Retrieving Settings Controller to change system themes
  final SettingsController settingsController;
  @override
  State<SavedNewsScreen> createState() => _SavedNewsScreenState();
}

class _SavedNewsScreenState extends State<SavedNewsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text("SavedNewsScre2en");
  }
}

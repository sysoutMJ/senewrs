import 'package:flutter/material.dart';
import 'package:senewrs/src/settings/settings_controller.dart';
import 'package:senewrs/src/settings/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.settingsController});

  // Retrieving Settings Controller to change system themes
  final SettingsController settingsController;
  @override
  State<SettingsScreen> createState() => _SettingsScreeState();
}

class _SettingsScreeState extends State<SettingsScreen> {
  // Easy to change values
  final lightIcon = const AssetImage("assets/images/light_icon.png");
  final darkIcon = const AssetImage("assets/images/dark_icon.png");
  // CHANGE TO USER PREFERENCE FONT
  late double fontSize;
  double widgetGaps = 20;

  @override
  void initState() {
    fontSize = widget.settingsController.settingsService.getFontSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Dynamic Border
      child: FractionallySizedBox(
        alignment: Alignment.center,
        // Only consume X percent of Screen
        widthFactor: 0.8,
        // Main Column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSystemThemeToggle(),
            SizedBox(height: widgetGaps),
            _buildFontSizeWidget(),
          ],
        ),
      ),
    );
  }

  // Builds System Theme Toggle Widget
  Widget _buildSystemThemeToggle() {
    return ElevatedButton(
      onPressed: () {
        SettingsService.isDarkMode(widget.settingsController.themeMode)
            ? widget.settingsController.updateThemeMode(ThemeMode.light)
            : widget.settingsController.updateThemeMode(ThemeMode.dark);
        // Rebuilding Screen
        setState(() {});
      },
      child: Row(
        children: [
          // Icon
          CircleAvatar(
            radius: 20,
            backgroundImage:
                SettingsService.isDarkMode(widget.settingsController.themeMode)
                    ? darkIcon
                    : lightIcon,
          ),
          // Text
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SettingsService.isDarkMode(
                      widget.settingsController.themeMode)
                  ? const Text("Dark Mode")
                  : const Text("Light Mode"),
            ),
          ),
        ],
      ),
    );
  }

  // Builds Font Dropdown Widget
  Widget _buildFontDropDown() {
    List<String> fonts = ["Arial", "Courier New", "Roboto", "Times New Roman"];
    return DropdownMenu<String>(
      initialSelection: fonts.first,
      onSelected: (String? selected) => print("changing font..."),
      dropdownMenuEntries: fonts
          .map<DropdownMenuEntry<String>>(
            (String fontName) =>
                DropdownMenuEntry<String>(value: fontName, label: fontName),
          )
          .toList(),
    );
  }

  // Builds Font Size Adjuster Widget
  Widget _buildFontSizeWidget() {
    // Easy to change values
    const double fontSizeSteps = 3;
    const Color lightContainerColor = Color(0xffE7E7E7);
    const Color darkContainerColor = Color(0xff555555);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Font Size Text
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                SettingsService.isDarkMode(widget.settingsController.themeMode)
                    ? darkContainerColor
                    : lightContainerColor,
          ),
          child: Text(
            "Font Size",
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        // Gap
        const SizedBox(height: 10),
        // Font Adjuster Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Minus Button
            ElevatedButton(
              onPressed: () => setState(
                () {
                  fontSize -= fontSizeSteps;
                  _updateFontSize(fontSize);
                },
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(Icons.remove),
            ),
            Text(fontSize.toInt().toString()),
            // Plus Button
            ElevatedButton(
              onPressed: () => setState(
                () {
                  fontSize += fontSizeSteps;
                  _updateFontSize(fontSize);
                },
              ),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(Icons.add),
            ),
          ],
        )
      ],
    );
  }

  // Used to save font size to system
  void _updateFontSize(double fontSize) {
    widget.settingsController.settingsService.saveFontSize(fontSize);
  }
}

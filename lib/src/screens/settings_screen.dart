import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  double widgetGaps = 20;

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
    var fontSize = widget.settingsController.fontSize > 31.0
        ? 30.0
        : widget.settingsController.fontSize;
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
              child: Text(
                SettingsService.isDarkMode(widget.settingsController.themeMode)
                    ? "Dark Mode"
                    : "Light Mode",
                style: GoogleFonts.robotoSerif(
                  textStyle: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
              ),
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
            style: GoogleFonts.robotoSerif(
                fontSize: widget.settingsController.fontSize),
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
              onPressed: () {
                // If font size is > 28
                if (widget.settingsController.fontSize > 28) {
                  setState(
                    () {
                      _updateFontSize(
                          widget.settingsController.fontSize - fontSizeSteps);
                    },
                  );
                  // else, show error
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Minimum size of font is 27!"),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(Icons.remove),
            ),
            Text(widget.settingsController.fontSize.toInt().toString()),
            // Plus Button
            ElevatedButton(
              onPressed: () => setState(
                () {
                  if (widget.settingsController.fontSize < 66) {
                    _updateFontSize(
                        widget.settingsController.fontSize + fontSizeSteps);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Maximum size of font is 66!"),
                      ),
                    );
                  }
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
    widget.settingsController.updateFontSize(fontSize);
  }
}

import 'package:flutter/material.dart';
import 'package:senewrs/src/screens/news_screen.dart';
import 'package:senewrs/src/settings/settings_controller.dart';
import 'package:senewrs/src/settings/settings_service.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _searchController = TextEditingController();
  String? _searchBy = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Text Field
            Flexible(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: "Search",
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: SettingsService.isDarkMode(
                            widget.settingsController.themeMode)
                        ? const Color(0xff1C1C1C)
                        : Colors.white),
              ),
            ),

            // Search Button
            FilledButton(
              onPressed: () {
                String _httpQuery = "";
                // If publisher radio button is selected
                if (_searchBy == "publisher") {
                  _httpQuery =
                      "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&sources=${_searchController.text.toLowerCase()}&categories=general&languages=en&limit=100";
                  // Else
                } else {
                  _httpQuery =
                      "http://api.mediastack.com/v1/news?access_key=d6c18569c8f76b70358140cd212c058c&categories=general&languages=en&keywords=${_searchController.text.toLowerCase()}&limit=100";
                }

                // Navigate to page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => NewsScreen(
                      settingsController: widget.settingsController,
                      category: '"${_searchController.text}"',
                      httpQuery: _httpQuery,
                      hasBackButton: true,
                    ),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(30, 64),
                shape: const ContinuousRectangleBorder(),
                backgroundColor: Colors.black,
              ),
              child: const Icon(
                Icons.search,
                size: 40,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Search by:"),
            Radio(
              value: "publisher",
              groupValue: _searchBy,
              onChanged: (value) => setState(
                () => _searchBy = value,
              ),
            ),
            const Text("Publisher"),
            Radio(
              value: "keyword",
              groupValue: _searchBy,
              onChanged: (value) => setState(
                () => _searchBy = value,
              ),
            ),
            Text("Keyword"),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: SettingsService.isDarkMode(widget.settingsController.themeMode)
                  ? const Color(0xffE3E3E3)
                  : const Color(0xff969696),
          ),
          child: Row(
            children: [
              // Text Field
              Flexible(
                child: Container(
                  margin: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none
                        ),
                        filled: true,
                        fillColor: SettingsService.isDarkMode(
                            widget.settingsController.themeMode)
                            ? const Color(0xff1C1C1C)
                            : Colors.white),
                  ),
                )
              ),

              // Search Button
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                child: FilledButton(
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

                    // Storing user search query
                    final searchQuery = _searchController.text;

                    // Navigate to page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => NewsScreen(
                          settingsController: widget.settingsController,
                          category: '"${searchQuery}"',
                          httpQuery: _httpQuery,
                          hasBackButton: true,
                          hasSearchWidget: true,
                        ),
                      ),
                    );

                    // Clear search bar
                    _searchController.clear();
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                    minimumSize: const Size(30, 64),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: const Color(0xff000000),
                  ),
                  child:
                    Image.asset('assets/images/light-mode-search-button.png')
                ),
              )
            ],
          ),
        )
        ,
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

import 'package:flutter/material.dart';
import 'InputScreen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

  final List<String> _suggestions = [
    'Chocolate Chip Cookies',
    'Lasagna',
    'Spaghetti Carbonara',
    'Grilled Cheese Sandwich',
    'Roast Chicken',
  ];
  String? _selectedRecipe;

class RecipeGPTApp extends StatelessWidget {
  const RecipeGPTApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe GPT'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Recipe GPT!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: 'Search for a recipe',
                  border: OutlineInputBorder(),
                ),
              ),
              suggestionsCallback: (pattern) {
                return _suggestions
                    .where((recipe) =>
                        recipe.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                _selectedRecipe = suggestion;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_selectedRecipe != null) {
                   Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InputScreen()),
                      );
                } else {
                  // Show an error message.
                }
              },
              child: Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}

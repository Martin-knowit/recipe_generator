import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/recipe.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final _foodItemsController = TextEditingController();
  final _recipes = <Recipe>[];
  bool _isLoading = false;

  @override
  void dispose() {
    _foodItemsController.dispose();
    super.dispose();
  }

  void _fetchRecipes() async {
    setState(() {
      _isLoading = true;
    });

    final foodItems = _foodItemsController.text.split(',');
    final apiUrl = 'https://food-recipe-api.com/recipes?foodItems=${foodItems.join('+')}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List;
      final recipes = jsonList.map((json) => Recipe.fromJson(json)).toList();

      setState(() {
        _recipes.clear();
        _recipes.addAll(recipes);
      });
    } else {
      throw Exception('Failed to fetch recipes');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Recipes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _foodItemsController,
              decoration: InputDecoration(
                hintText: 'Enter food items separated by commas',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _fetchRecipes,
            child: _isLoading
                ? CircularProgressIndicator()
                : Text('Get Recipes'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                return ListTile(
                  leading: Image.network(recipe.imageUrl),
                  title: Text(recipe.title),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
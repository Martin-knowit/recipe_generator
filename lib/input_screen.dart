import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:recipe_generator/API/ChatGPT.dart';
import 'ingredients.dart';
import 'result.dart';
import 'Recipe.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  List<String> selectedProducts = [];

  final TextEditingController _typeAheadController = TextEditingController();

  @override
  void dispose() {
    _typeAheadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Screen'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.blueGrey.shade100,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    for (final product in selectedProducts)
                      Chip(
                        label: Text(product),
                        deleteIcon: Icon(Icons.clear),
                        onDeleted: () => _removeProduct(product),
                        backgroundColor: Colors.blue,
                      ),
                  ],
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Card(
                    elevation: 5.0,
                    shadowColor: Colors.black.withOpacity(0.5),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _typeAheadController,
                        decoration: InputDecoration(
                          labelText: 'Search or add food products',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onEditingComplete: () {
                          final value = _typeAheadController.text;
                          _typeAheadController.clear();
                          _addProduct(value);
                        },
                      ),
                      suggestionsCallback: (pattern) {
                        return [
                          ...foodProducts
                              .where((product) => product
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList(),
                          if (pattern.isNotEmpty) pattern,
                        ];
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        _typeAheadController.clear();
                        _addProduct(suggestion);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    Recipe recipe = await getRecipe(selectedProducts.join(", "));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeWidget(recipe: recipe),
                        ),
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 48.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5.0,
                    animationDuration: Duration(milliseconds: 200),
                    shadowColor: Colors.black.withOpacity(0.5),
                  ),
                  child: Text(
                    'Get Recipe',
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addProduct(String product) {
    setState(() {
      selectedProducts.add(product);
    });
  }

  void _removeProduct(String product) {
    setState(() {
      selectedProducts.remove(product);
    });
  }
}

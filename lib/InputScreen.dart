import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  List<String> selectedProducts = [];

  final List<String> foodProducts = [
    'Apple',
    'Banana',
    'Broccoli',
    'Carrot',
    'Celery',
    'Cheese',
    'Egg',
    'Fish',
    'Garlic',
    'Lettuce',
    'Milk',
    'Orange',
    'Potato',
    'Spinach',
    'Tomato',
    'Turkey',
    'Watermelon',
    'Yogurt',
    'Zucchini',
  ];

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  decoration: InputDecoration(
                    labelText: 'Search or add food products',
                    border: OutlineInputBorder(),
                  ),
                  onEditingComplete: () {
                    final value = _typeAheadController.text;
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
                  _typeAheadController.text = '';
                  _addProduct(suggestion);
                },
              ),
              SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                children: [
                  for (final product in selectedProducts)
                    Chip(
                      label: Text(product),
                      deleteIcon: Icon(Icons.clear),
                      onDeleted: () => _removeProduct(product),
                    ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  print({'selected_products': selectedProducts});
                },
                child: Text('Submit'),
              ),
            ],
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

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  List<String> selectedProducts = [];

  final List<String> foodProducts = [    'Apple',    'Banana',    'Broccoli',    'Carrot',    'Celery',    'Cheese',    'Egg',    'Fish',    'Garlic',    'Lettuce',    'Milk',    'Orange',    'Potato',    'Spinach',    'Tomato',    'Turkey',    'Watermelon',    'Yogurt',    'Zucchini',  ];

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
            colors: [
              Color(0xFFD9AFD9),
              Color(0xFF97D9E1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: InputDecoration(
                  labelText: 'Search for food products',
                  border: OutlineInputBorder(),
                ),
              ),
              suggestionsCallback: (pattern) {
                return foodProducts
                    .where((product) =>
                        product.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) {
                _typeAheadController.text = '';
                setState(() {
                  selectedProducts.add(suggestion);
                });
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
                    onDeleted: () {
                      setState(() {
                        selectedProducts.remove(product);
                      });
                    },
                  ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                print({'selected_products': selectedProducts});
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 10,
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

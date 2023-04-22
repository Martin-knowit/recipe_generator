import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'ingredients.dart';
import 'result.dart';
import 'Recipe.dart';
import 'dart:math';
import 'API/ChatGPT.dart';

List<String> randomIngredients(int count) {
  List<String> selectedIngredients = [];
  Random random = Random();

  // Pick random ingredients from the array
  while (selectedIngredients.length < count) {
    String ingredient = foodProducts[random.nextInt(foodProducts.length)];
    if (!selectedIngredients.contains(ingredient)) {
      selectedIngredients.add(ingredient);
    }
  }

  return selectedIngredients;
}

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  List<String> selectedProducts = [];
  bool isLoading = false;

  final TextEditingController _typeAheadController = TextEditingController();

  @override
  void dispose() {
    _typeAheadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/start-background.png',
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      if (!isLoading) ...[
                        SelectedProducts(
                          selectedProducts: selectedProducts,
                          removeProduct: _removeProduct,
                        ),
                        SizedBox(height: 16.0),
                        SearchBar(
                          typeAheadController: _typeAheadController,
                          addProduct: _addProduct,
                          selectedProducts: selectedProducts,
                        ),
                        SizedBox(height: 32.0),
                        Wrap(
                          spacing: 8.0, // Space between the buttons horizontally
                          runSpacing: 8.0, // Space between the buttons vertically
                          alignment: WrapAlignment.center, // Center the buttons horizontally
                          children: [
                            GenerateRecipeButton(
                                selectedProducts: selectedProducts,
                                onPressed: _generateRecipe),
                            GenerateRandomRecipeButton(
                              onPressed: (List<String> randomSelectedProducts) {
                                setState(() {
                                  selectedProducts = randomSelectedProducts;
                                });
                                _generateRecipe();
                              }),
                          ],
                        ),
                      ],
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: LoadingView(),
            ),
        ],
      ),
    );
  }

  void _addProduct(String product) {
    product = product.trim();
    if (selectedProducts
            .where((a) => a.toLowerCase() == product.toLowerCase())
            .isEmpty &&
        product.isNotEmpty) {
      setState(() {
        selectedProducts.add(product);
      });
    }
  }

  void _removeProduct(String product) {
    setState(() {
      selectedProducts.remove(product);
    });
  }

  Future<void> _generateRecipe() async {
    setState(() {
      isLoading = true;
    });

    try {
      Recipe recipe = await getRecipe(selectedProducts.join(", "));

      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeWidget(recipe: recipe),
        ),
      );
    } on ApiException catch (e) {
      print('ApiException: ${e.message}');
      // Show an appropriate error message to the user

      final snackBar = SnackBar(
        content: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(); // Dismiss the Snackbar when tapped
          },
          child: Text(e.message),
        ),
        backgroundColor: Colors.red,
        duration: Duration(days: 365), // Set a very high value for duration
        behavior: SnackBarBehavior
            .floating, // Make the Snackbar float above other UI elements
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {
        isLoading = false;
      });
    }
  }
}

class SelectedProducts extends StatelessWidget {
  final List<String> selectedProducts;
  final Function(String) removeProduct;

  SelectedProducts(
      {required this.selectedProducts, required this.removeProduct});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (final product in selectedProducts)
          Chip(
            label: Text(product),
            deleteIcon: Icon(Icons.clear),
            onDeleted: () => removeProduct(product),
            backgroundColor: Colors.blue,
          ),
      ],
    );
  }
}

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double maxSize = 500;

    double width = min(screenWidth, maxSize);
    double height = min(screenHeight * 0.5, maxSize);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/cooking.json', // Replace with the correct path to your animation file
            width: width,
            height: height,
          ),
          Text(
            'Skapar matmagi...',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline4?.fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController typeAheadController;
  final Function(String) addProduct;
  final List<String> selectedProducts;

  SearchBar({
    required this.typeAheadController,
    required this.addProduct,
    required this.selectedProducts,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Card(
        elevation: 5.0,
        shadowColor: Colors.black.withOpacity(0.5),
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: typeAheadController,
            decoration: InputDecoration(
              labelText: 'Search or add food products',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
            ),
            onEditingComplete: () {
              final value = typeAheadController.text;
              typeAheadController.clear();
              addProduct(value);
            },
          ),
          suggestionsCallback: (pattern) {
            return [
              ...foodProducts
                  .where((product) =>
                      selectedProducts
                          .where(
                              (a) => a.toLowerCase() == product.toLowerCase())
                          .isEmpty &&
                      product.toLowerCase().contains(pattern.toLowerCase()))
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
            typeAheadController.clear();
            addProduct(suggestion);
          },
        ),
      ),
    );
  }
}

class GenerateRecipeButton extends StatelessWidget {
  final List<String> selectedProducts;
  final VoidCallback onPressed;

  GenerateRecipeButton({
    required this.selectedProducts,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
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
        primary: Colors.blue,
      ),
      child: Text(
        'Generate Recipe',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class GenerateRandomRecipeButton extends StatelessWidget {
  final Function(List<String>) onPressed;

  GenerateRandomRecipeButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Generate random ingredients using the randomIngredients() function
        List<String> ingredients = randomIngredients(8);
        onPressed(ingredients);
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
        primary: Colors.blue,
      ),
      child: Text(
        'Surprise me!',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

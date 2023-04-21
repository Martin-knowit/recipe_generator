import 'package:flutter/material.dart';
import 'RecipeGPTApp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe GPT App',
      home: const RecipeGPTApp(),
    );
  }
}

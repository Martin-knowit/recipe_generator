import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeScreen extends StatefulWidget {
  final String recipeName;

  RecipeScreen({required this.recipeName});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    getImageUrl();
  }

  void getImageUrl() async {
    final String apiKey = '5UzdEVUJmaUaQ2e9MWcDcb0MM8kfqnSQKG6orhg8pM67PWbKxvgfth1q';
    final String query = widget.imageQueryText;
    final String url = 'https://api.pexels.com/v1/search?query=$query&per_page=1&size=medium&orientation=landscape&locale=sv-SE';

    final response = await http.get(Uri.parse(url), headers: {'Authorization': apiKey});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        imageUrl = data['photos'][0]['src']['medium'];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeName),
      ),
      body: Center(
        child: imageUrl.isNotEmpty
            ? Image.network(imageUrl)
            : CircularProgressIndicator(),
      ),
    );
  }
}

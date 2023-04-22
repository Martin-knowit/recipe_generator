import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'Recipe.dart';
import 'package:http/http.dart' as http;

class RecipeWidget extends StatefulWidget {
  final Recipe recipe;

  RecipeWidget({required this.recipe});

  @override _RecipeWidgetState createState() => _RecipeWidgetState();
}

class _RecipeImage extends StatelessWidget {
  final String imageUrl;

  const _RecipeImage({required Key key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      height: 200.0,
    );
  }
}

class _RecipeWidgetState extends State<RecipeWidget> {
  String imageUrl = '';
  @override
  void initState() {
    super.initState();
    getImageUrl();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x44000000),
        elevation: 0,
        title: Text("Ditt personliga recept"),
      ),
      body: Container(
  height: MediaQuery.of(context).size.height,
  decoration: BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.grey[200]!,
      Colors.grey[300]!,
    ],
  ),
),

  child: Padding(
    padding: const EdgeInsets.all(24.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text(
                  widget.recipe.name,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Color(0x80FFFFFF),
            ),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              spacing: 8.0, // adjust the spacing between the children
              runSpacing: 8.0, // adjust the spacing between the rows
              runAlignment: WrapAlignment.center, // center the wrapped rows vertically
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prepp-tid',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(widget.recipe.prepTime),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tillagningstid',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(widget.recipe.cookTime),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total tid',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(widget.recipe.totalTime),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Portioner',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(widget.recipe.servings.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            widget.recipe.description,
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          Text(
            'Ingredienser:',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.recipe.ingredients.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 8.0);
            },
            itemBuilder: (BuildContext context, int index) {
              return Text(widget.recipe.ingredients[index]);
            },
          ),
          SizedBox(height: 16.0),
          Text(
            'Instruktioner:',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: widget.recipe.directions.length,
  itemBuilder: (BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[800],
        child: Container(
          child: Text(
            (index + 1).toString(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      title: Text(widget.recipe.directions[index]),
    );
  },
),

        ],
      ), 
    ), 
  ), 
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      final text = recipeToString(widget.recipe);
      Share.share('${text}');
    },
    backgroundColor: Colors.green[200], // set background color to mellow green
    child: Icon(Icons.share),
),

); 
  }

  String recipeToString(Recipe recipe) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln("Jag har precis skapat ett helt AI-genererat recept med Recipe Wizard!");
  buffer.writeln("");
  buffer.writeln('${recipe.name}');
  buffer.writeln('${recipe.description}');
  buffer.writeln("");
  buffer.writeln('Ingredienser:');
  for (final ingredient in recipe.ingredients) {
    buffer.writeln('- $ingredient');
  }
  buffer.writeln("");
  buffer.writeln('Anvisningar:');
  for (int i = 0; i < recipe.directions.length; i++) {
    buffer.writeln('${i + 1}. ${recipe.directions[i]}');
  }
  buffer.writeln("");
  buffer.writeln('Prepp-tid: ${recipe.prepTime}');
  buffer.writeln('Tillagningstid: ${recipe.cookTime}');
  buffer.writeln('Total tid: ${recipe.totalTime}');
  buffer.writeln('Portioner: ${recipe.servings}');
  return buffer.toString();
}


  void getImageUrl() async {
    final String apiKey = '5UzdEVUJmaUaQ2e9MWcDcb0MM8kfqnSQKG6orhg8pM67PWbKxvgfth1q';
    final String query = widget.recipe.imageQueryText;
    final String url = 'https://api.pexels.com/v1/search?query=$query&per_page=1&size=medium&orientation=square&locale=sv-SE';

    final response = await http.get(Uri.parse(url), headers: {'Authorization': apiKey});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['photos'] != null && data['photos'].isNotEmpty) {
        setState(() {
          imageUrl = data['photos'][0]['src']['medium'];
        });
      } else {
        print('No photos found');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
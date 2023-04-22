import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
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
        title: Text(
          widget.recipe.name,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prep Time',
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
                              'Cook Time',
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Time',
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
                              'Servings',
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
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.recipe.description,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Ingredients:',
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
                  'Instructions:',
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
                        child: Text((index + 1).toString()),
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
    );
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
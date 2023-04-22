class Recipe {
  String name;
  String description;
  List<String> ingredients;
  List<String> directions;
  String prepTime;
  String cookTime;
  String totalTime;
  int servings;
  String imageQueryText;

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.directions,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.servings,
    required this.imageQueryText,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      description: json['description'],
      ingredients: List<String>.from(json['ingredients']),
      directions: List<String>.from(json['directions']),
      prepTime: json['prep_time'],
      cookTime: json['cook_time'],
      totalTime: json['total_time'],
      servings: json['servings'],
      imageQueryText: json['image_query_text'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['ingredients'] = this.ingredients;
    data['directions'] = this.directions;
    data['prep_time'] = this.prepTime;
    data['cook_time'] = this.cookTime;
    data['total_time'] = this.totalTime;
    data['servings'] = this.servings;
    data['image_query_text'] = this.imageQueryText;
    return data;
  }
}

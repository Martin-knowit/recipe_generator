class Recipe {
  final String title;
  final String imageUrl;

  Recipe({
    required this.title,
    required this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      imageUrl: json['imageUrl'],
    );
  }
}
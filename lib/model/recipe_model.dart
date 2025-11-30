class RecipeModel {
  final int id;
  final String title;
  final String kategori;
  final String rating;
  final String ingredients;
  final String steps;
  final String description;
  final String image_url;
  final String time;
  final String difficulty;
  final String author;

  RecipeModel({
    required this.id,
    required this.title,
    required this.kategori,
    required this.rating,
    required this.ingredients,
    required this.steps,
    required this.description,
    required this.image_url,
    required this.time,
    required this.difficulty,
    required this.author,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int,
      title: json['title'] as String,
      kategori: json['kategori'] as String,
      rating: json['rating'].toString(),
      ingredients: json['ingredients'] as String,
      steps: json['steps'] as String,
      description: json['description'] as String,
      image_url: json['image_url'] as String,
      time: json['time'] as String,
      difficulty: json['difficulty'] as String,
      author: json['author'] as String,
    );
  }
}

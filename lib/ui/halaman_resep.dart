import 'package:flutter/material.dart';
import 'package:uasmoba/widgets/card_recipe.dart';

class HalamanResep extends StatelessWidget {
  // Simulasi Data yang sudah di-fetch dan di-decode dari JSON
  static const List<Map<String, dynamic>> dummyRecipes = [
    {
      'title': 'Bening Sawi Jagung',
      'imageUrl': 'URL_SAWI_JAGUNG',
      'rating': 5.0,
      'steps': 5,
      'author': 'Ovie Kholifatun',
    },
    {
      'title': 'Alpukat Kocok',
      'imageUrl': 'URL_ALPUKAT_KOCOK',
      'rating': 4.6,
      'steps': 5,
      'author': 'Yummy Official',
    },
    {
      'title': 'Bumbu Dasar Putih #YummyResepDasar',
      'imageUrl': 'URL_BUMBU_PUTIH',
      'rating': 4.8,
      'steps': 20,
      'author': 'Yummy Official',
    },
    {
      'title': 'Pisang Caramel',
      'imageUrl': 'URL_PISANG_CARAMEL',
      'rating': 4.9,
      'steps': 5,
      'author': 'Mama Queen',
    },
  ];

  final List<Map<String, dynamic>> recipes = dummyRecipes;

  const HalamanResep({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Resep-resep')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            GridView.builder(
              // Properti Penting untuk GridView di dalam SingleChildScrollView
              shrinkWrap: true, // Membuat GridView hanya sebesar isinya
              physics:
                  const NeverScrollableScrollPhysics(), // Menonaktifkan scroll GridView, agar scroll ditangani oleh SingleChildScrollView

              itemCount: recipes.length, // Jumlah item (data resep)
              // Delegasi untuk mengatur tata letak Grid
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 10.0, // Jarak horizontal antar Card
                mainAxisSpacing: 10.0, // Jarak vertikal antar Card
                childAspectRatio:
                    0.7, // Rasio lebar/tinggi (untuk memastikan Card cukup tinggi)
              ),
              // Fungsi yang membangun setiap item Grid
              itemBuilder: (context, index) {
                final recipe = recipes[index];

                // ➡️ PANGGILAN PARTIAL CARD ANDA DI SINI
                return RecipeCard(
                  // Meneruskan data dari list ke constructor RecipeCard
                  imageUrl: recipe['imageUrl'] ?? 'placeholder_url',
                  title: recipe['title'],
                  rating: recipe['rating'].toString(),
                  steps: recipe['steps'],
                  author: recipe['author'],
                  // Opsional: key: ValueKey(recipe['id']),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

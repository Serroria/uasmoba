// lib/home_page.dart

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- 1. Area Filter/Kategori Resep ---
          const Text(
            'Filter Kategori Resep:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40, // Tinggi untuk daftar Chip (kategori)
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const <Widget>[
                CategoryChip(label: 'Semua'),
                CategoryChip(label: 'Nusantara'),
                CategoryChip(label: 'Asia'),
                CategoryChip(label: 'Internasional'),
                CategoryChip(label: 'Vegan'),
              ],
            ),
          ),

          const Divider(height: 30),

          // --- 2. Judul Resep Populer ---
          const Text(
            'Resep Populer Minggu Ini',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          // --- 3. Daftar Card Resep (Placeholder) ---
          RecipeCard(
            title: 'Nasi Goreng Spesial',
            duration: '20 Menit',
            imageUrl:
                'https://images.unsplash.com/photo-1545638206-8d591b9423b9', // Ganti dengan URL/Aset Gambar asli
          ),
          RecipeCard(
            title: 'Sate Ayam Madura',
            duration: '45 Menit',
            imageUrl:
                'https://images.unsplash.com/photo-1589302636881-197e55ed13c0',
          ),
          // Tambahkan lebih banyak RecipeCard di sini...
          const SizedBox(height: 50), // Ruang bawah agar tidak terpotong navbar
        ],
      ),
    );
  }
}

// Widget untuk Chip Kategori (Reusable)
class CategoryChip extends StatelessWidget {
  final String label;

  const CategoryChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.deepOrange.shade50,
        labelStyle: TextStyle(color: Colors.deepOrange.shade700),
      ),
    );
  }
}

// Widget untuk Card Resep (Reusable)
class RecipeCard extends StatelessWidget {
  final String title;
  final String duration;
  final String imageUrl;

  const RecipeCard({
    super.key,
    required this.title,
    required this.duration,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Resep
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                color: Colors.grey.shade200,
                child: const Center(child: Text('Gagal Muat Gambar')),
              ),
            ),
          ),
          // Detail Resep
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(duration, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

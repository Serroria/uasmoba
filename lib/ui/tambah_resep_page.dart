// lib/ui/tambah_resep_page.dart
import 'package:flutter/material.dart';

class TambahResepPage extends StatefulWidget {
  const TambahResepPage({super.key});

  @override
  State<TambahResepPage> createState() => _TambahResepPageState();
}

class _TambahResepPageState extends State<TambahResepPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String? _selectedKategori;
  final List<String> _kategoriList = [
    'Nusantara',
    'Asia',
    'Western',
    'Vegetarian',
    'Minuman',
  ];
  String _difficulty = 'Mudah';
  final List<String> _difficultyLevels = ['Mudah', 'Sedang', 'Sulit'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submitRecipe() {
    if (_formKey.currentState!.validate()) {
      // Simulasi data resep baru
      final newRecipe = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': _titleController.text,
        'kategori': _selectedKategori,
        'description': _descriptionController.text,
        'image_url':
            'https://picsum.photos/id/${DateTime.now().millisecondsSinceEpoch % 100 + 300}/200',
        'rating': 4.5,
        'time': _timeController.text,
        'difficulty': _difficulty,
      };

      Navigator.pop(context, newRecipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Tambah Resep Baru",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _submitRecipe,
            child: const Text(
              "Simpan",
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Gambar resep (placeholder)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 50,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tambahkan Foto Resep",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form fields
              _buildTextField(
                controller: _titleController,
                label: "Judul Resep",
                hintText: "Contoh: Nasi Goreng Spesial",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul resep harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _descriptionController,
                label: "Deskripsi",
                hintText: "Deskripsi singkat tentang resep ini",
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Waktu dan Tingkat Kesulitan
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kategori",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedKategori,
                          hint: const Text('Pilih Kategori'),
                          items: _kategoriList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedKategori = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kategori harus dipilih';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _timeController,
                      label: "Waktu Memasak",
                      hintText: "Contoh: 30 menit",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Waktu memasak harus diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tingkat Kesulitan",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _difficulty,
                          items: _difficultyLevels.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _difficulty = value!;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _ingredientsController,
                label: "Bahan-bahan",
                hintText: "Tulis bahan-bahan yang diperlukan...",
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bahan-bahan harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _stepsController,
                label: "Langkah-langkah",
                hintText: "Tulis langkah-langkah memasak...",
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Langkah-langkah harus diisi';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}

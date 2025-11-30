// lib/ui/tambah_resep_page.dart

import 'package:flutter/material.dart';
import 'package:uasmoba/services/api_service.dart';
// 👇 IMPORT YANG DITAMBAHKAN
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// 👆 IMPORT YANG DITAMBAHKAN

class TambahResepPage extends StatefulWidget {
  const TambahResepPage({super.key});

  @override
  State<TambahResepPage> createState() => _TambahResepPageState();
}

class _TambahResepPageState extends State<TambahResepPage> {
  // 👇 DEKLARASI STATE UNTUK FILE GAMBAR
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // MENGGUNAKAN _imageFile
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
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

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submitRecipe() async {
    // Memastikan form valid dan kategori sudah dipilih
    if (_formKey.currentState!.validate() && _selectedKategori != null) {
      setState(() {
        _isLoading = true; // Aktifkan loading saat submit
      });

      // 1. Kumpulkan Data (Kunci harus SAMA dengan kolom database CI4 Anda)
      final Map<String, dynamic> newRecipeData = {
        'title': _titleController.text,
        'kategori':
            _selectedKategori!, // Pastikan nilai ada karena sudah divalidasi
        'description': _descriptionController.text,
        'ingredients': _ingredientsController.text, // Kolom TEXT di DB
        'steps': _stepsController.text, // Kolom TEXT di DB
        'time': _timeController.text,
        'difficulty': _difficulty, // Dari Dropdown
        // Data yang di-hardcode sementara:
        'rating': 4.5, // Ganti dengan 0 atau NULL jika rating diisi belakangan
        'user_id': 1,
      };

      try {
        // 2. Kirim Data ke API CI4
        // Mengirim data teks (newRecipeData) dan file gambar (_imageFile)
        final result = await ApiService.postRecipe(newRecipeData, _imageFile);

        // 3. Jika Berhasil
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resep berhasil disimpan!')),
          );
          Navigator.pop(context, result); // Tutup dan kirim hasil data
        }
      } catch (e) {
        // 4. Jika Gagal
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal menyimpan resep: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Non-aktifkan loading
          });
        }
      }
    } else {
      // Kasus ketika validasi gagal (misal kategori belum dipilih)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua form yang wajib diisi.'),
        ),
      );
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
            onPressed: _isLoading
                ? null
                : _submitRecipe, // Nonaktifkan saat loading
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.deepOrange,
                    ),
                  )
                : const Text(
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
              // Gambar resep
              GestureDetector(
                onTap: _pickImage, // Panggil fungsi pick image
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    // Tampilkan gambar yang dipilih, atau placeholder
                    image:
                        _imageFile !=
                            null // MENGGUNAKAN _imageFile
                        ? DecorationImage(
                            image: FileImage(
                              _imageFile!,
                            ), // MENGGUNAKAN _imageFile
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child:
                      _imageFile ==
                          null // MENGGUNAKAN _imageFile
                      ? Column(
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
                        )
                      : null, // Jika gambar sudah ada, jangan tampilkan placeholder
                ),
              ),
              // Saya menghapus Container placeholder yang duplikat di sini
              const SizedBox(height: 24),

              // 1. Judul Resep
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

              // 2. Deskripsi
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

              // 3. Kategori, Waktu, dan Kesulitan (Layout 3 kolom)
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
                          decoration: _getDropdownInputDecoration(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _timeController,
                      label: "Waktu Memasak",
                      hintText: "30 menit",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Waktu harus diisi';
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
                          "Tingkat Kesulitan!",
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
                          decoration: _getDropdownInputDecoration(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Bahan-bahan
              _buildTextField(
                controller: _ingredientsController,
                label: "Bahan-bahan",
                hintText: "Contoh: 1 sdt Garam, 200 gr Ayam...",
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bahan-bahan harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 5. Langkah-langkah
              _buildTextField(
                controller: _stepsController,
                label: "Langkah-langkah",
                hintText: "Contoh: 1. Panaskan minyak. 2. Masukkan bumbu...",
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

  // Widget pembantu untuk TextField
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

  // Widget pembantu untuk dekorasi Dropdown
  InputDecoration _getDropdownInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // 💡 PENTING: Tambahkan ini untuk kelas File!
import '../model/recipe_model.dart';

const String _apiUrlBase =
    'http://10.0.2.2/uasmoba/public/api/resep'; // 💡 Perbaiki variabel nama jika sebelumnya 'apiUrl'

// api post
class ApiService {
  Future<List<RecipeModel>> fetchRecipes() async {
    final response = await http.get(Uri.parse(_apiUrlBase));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      print('Gagal memuat resep. Status Code: ${response.statusCode}');
      throw Exception('Gagal memuat resep dari CI4 API');
    }
  }

  // 💡 Hanya pertahankan fungsi ini untuk upload resep dengan file
  static Future<Map<String, dynamic>> postRecipe(
    Map<String, dynamic> data,
    File? imageFile, // Data File yang akan diupload
  ) async {
    // URL CI4 untuk request POST
    var uri = Uri.parse(_apiUrlBase);

    // Gunakan MultipartRequest untuk pengiriman file
    var request = http.MultipartRequest('POST', uri);

    // 1. Tambahkan Fields (Data Teks)
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // 2. Tambahkan File Gambar (Jika ada)
    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'image_url', // 💡 HARUS SAMA dengan kolom di DB & field di CI4! (Berdasarkan DB Anda: 'image_url')
        stream,
        length,
        filename: imageFile.path.split('/').last,
      );

      request.files.add(multipartFile);
    }

    // 3. Kirim Request
    var response = await request.send();

    // 4. Proses Respons
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return jsonDecode(responseBody);
    } else {
      print('CI4 Error Response: $responseBody');
      throw Exception(
        'Gagal mengirim data resep. Status: ${response.statusCode}',
      );
    }
  }
}
// Hapus semua kode tambahan setelah ini (misalnya class LoginPage yang tidak relevan dengan ApiService)
// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Login"),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             minHeight: MediaQuery.of(context).size.height - 80,
//           ),
//           child: IntrinsicHeight(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Spacer(),

//                 // Header
//                 Text(
//                   "Masuk untuk melihat resep favoritmu",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.deepOrange.shade400,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 32),

//                 // Form Card
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.deepOrange.shade50,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.deepOrange.withOpacity(0.1),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       // Email
//                       TextField(
//                         decoration: InputDecoration(
//                           hintText: "Email",
//                           prefixIcon: const Icon(Icons.email_outlined),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(
//                               color: Colors.deepOrange.shade200,
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(
//                               color: Colors.deepOrange.shade200,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(
//                               color: Colors.deepOrange.shade400,
//                               width: 2,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 18),

//                       // Password
//                       TextField(
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           hintText: "Password",
//                           prefixIcon: const Icon(Icons.lock_outline),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(
//                               color: Colors.deepOrange.shade200,
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(
//                               color: Colors.deepOrange.shade200,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(
//                               color: Colors.deepOrange.shade400,
//                               width: 2,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 26),

//                       // Login Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 48,
//                         child: ElevatedButton(
//                           onPressed: () =>
//                               Navigator.pushReplacementNamed(context, "/home"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.deepOrange,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             elevation: 3,
//                           ),
//                           child: const Text(
//                             "Login",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 14),

//                       // Register Redirect
//                       TextButton(
//                         onPressed: () =>
//                             Navigator.pushNamed(context, "/registrasi"),
//                         child: Text(
//                           "Belum punya akun? Registrasi",
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.deepOrange.shade700,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 40),
//                 const Spacer(),
//                 const Spacer(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

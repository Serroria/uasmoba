import 'package:flutter/material.dart';
import 'package:uasmoba/ui/halaman_resep.dart';
import 'homepage.dart';
import 'ui/login_page.dart';
import 'ui/registrasi_page.dart';
import 'widgets/bottom_nav.dart';
import 'ui/my_resep_page.dart';
import 'ui/tambah_resep_page.dart';
import 'ui/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplikasi Resep",
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      initialRoute: "/home",
      routes: {
        "/login": (context) => const LoginPage(),
        "/registrasi": (context) => const RegistrasiPage(),
        "/home": (context) => const HomePage(),
        "/my-resep": (context) => const MyResepPage(),
        "/tambah-resep": (context) => const TambahResepPage(),
        "/resep": (context) => const HalamanResep(),
        // Wrapper untuk navbar
        // ignore: equal_keys_in_map
        "/home": (context) => const NavWrapper(),
      },
    );
  }
}

class NavWrapper extends StatefulWidget {
  const NavWrapper({super.key});

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  int _index = 0;

  final List<Widget> _tabs = [
    const HomePage(),
    const HalamanResep(),
    const MyResepPage(),
    const ProfilePage(),
  ];

  void _tap(index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_index],
      bottomNavigationBar: BottomNav(currentIndex: _index, onTap: _tap),
    );
  }
}

import 'package:flutter/material.dart';
import 'homepage.dart';
import 'ui/login_page.dart';
import 'ui/registrasi_page.dart';
import 'widgets/bottom_nav.dart';

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
      initialRoute: "/login",
      routes: {
        "/login": (context) => const LoginPage(),
        "/registrasi": (context) => const RegistrasiPage(),
        "/home": (context) => const HomePage(),

        // Wrapper untuk navbar
        "/home": (context) => const NavWrapper(),
      },
    );
  }
}

// ✅ Wrapper Navbar (biar HomePage punya navbar bawah)
class NavWrapper extends StatefulWidget {
  const NavWrapper({super.key});

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  int _index = 0;

  final List<Widget> _tabs = [
    const HomePage(),
    const Center(child: Text("Kreasiku Page")),
    const Center(child: Text("Masak Page")),
    const Center(child: Text("Profil Page")),
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

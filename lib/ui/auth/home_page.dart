import 'package:flutter/material.dart';
import 'contact_page.dart';
import 'about_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Home aktif

  void _onMenuTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home page
        break;
      case 1:
        // Layanan belum ada, bisa tambahkan nanti
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ContactPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AboutPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2434),
        elevation: 0,
        title: const Text(
          "Borotara Motors",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          _buildNavButton("Home", 0),
          _buildNavButton("Layanan", 1),
          _buildNavButton("Kontak", 2),
          _buildNavButton("Tentang Kami", 3),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () => _onMenuTap(4),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.login, size: 18),
              label: const Text("Login"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 400,
              color: const Color(0xFF1C2434),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Selamat Datang di Borotara Motors",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Bengkel Motor Terpercaya untuk Kendaraan Anda",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Layanan Kami",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "• Servis Berkala\n"
                    "• Perbaikan Mesin\n"
                    "• Ganti Oli\n"
                    "• Tune Up\n"
                    "• Dan Lain-lain",
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(String title, int index) {
    final bool isActive = _selectedIndex == index;
    return TextButton(
      onPressed: () => _onMenuTap(index),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.orange[400] : Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

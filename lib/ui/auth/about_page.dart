import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contact_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'service_page.dart';


class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final String poppins = GoogleFonts.poppins().fontFamily ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],


      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2434),
        title: Text(
          "Borotara Motors",
          style: TextStyle(
            fontFamily: poppins,
            color: Colors.orange[400],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1C2434)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.directions_car,
                      color: Colors.orange, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Borotara Motors',
                    style: TextStyle(
                        fontFamily: poppins,
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Navigasi disesuaikan untuk halaman 'About'
            _drawerItem(
                'Home',
                Icons.home,
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomePage()))),
            _drawerItem(
                'Layanan',
                Icons.build_circle,
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const ServicePage()))),
            _drawerItem(
                'Kontak',
                Icons.phone,
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const ContactPage()))),
            _drawerItem(
              'Tentang Kami',
              Icons.info,
              // Karena ini Halaman 'Tentang Kami', kita tutup saja drawer-nya
              () => Navigator.pop(context),
            ),
            const Divider(),
            _drawerItem(
                'Login',
                Icons.login,
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginPage()))),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Deskripsi Perusahaan
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tentang Kami",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C2434),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Borotara Motors adalah bengkel khusus armada travel yang berlokasi di Bandung, "
                    "hadir sebagai mitra perawatan kendaraan yang andal, efisien, dan terintegrasi secara digital. "
                    "Kami berkomitmen untuk memberikan layanan servis yang tepat waktu dan menjaga performa kendaraan agar selalu optimal.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Kami memahami bahwa armada travel memiliki ritme operasional yang padat dan tuntutan kenyamanan tinggi. "
                    "Karena itu, kami menghadirkan layanan bengkel yang dirancang khusus untuk menjaga kelancaran perjalanan dan kepercayaan penumpang Anda.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1),

            // Bagian Visi & Misi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Layanan Terbaik, Dimulai dari Tujuan yang Jelas",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C2434),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Visi dan misi kami mencerminkan komitmen terhadap kualitas, efisiensi, dan dukungan penuh bagi armada travel Anda.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Kotak Visi dan Misi (YANG DIPERBAIKI)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isWide = constraints.maxWidth > 700;
                      return Flex(
                        direction: isWide ? Axis.horizontal : Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: isWide
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.stretch,
                        children: [
                          if (isWide)
                            Expanded(child: _buildVisiCard())
                          else
                            _buildVisiCard(),
                          if (isWide)
                            Expanded(child: _buildMisiCard())
                          else
                            _buildMisiCard(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange[400]),
      title: Text(title,
          style: TextStyle(fontFamily: poppins, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }


  // --- Widget Method untuk Visi ---
  Widget _buildVisiCard() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2434),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Visi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Menjadi bengkel armada travel terdepan di Bandung "
            "yang mengedepankan kualitas, ketepatan, dan kemudahan layanan "
            "berbasis digital untuk mendukung kelancaran operasional transportasi darat.",
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Method untuk Misi ---
  Widget _buildMisiCard() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2434),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Misi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "• Memberikan layanan perawatan dan perbaikan kendaraan travel yang cepat, profesional, dan terpercaya.\n\n"
            "• Mengembangkan sistem servis berbasis aplikasi untuk efisiensi operasional dan transparansi layanan.\n\n"
            "• Menjadi mitra strategis bagi pelaku usaha travel dalam menjaga performa armada dan kepuasan penumpang.",
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
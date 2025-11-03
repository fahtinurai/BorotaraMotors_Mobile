import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'about_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'service_page.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String poppins = GoogleFonts.poppins().fontFamily ?? '';

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
            _drawerItem(context, 'Home', Icons.home, const HomePage()),
            _drawerItem(context, 'Layanan', Icons.build_circle, const ServicePage()),
            _drawerItem(context, 'Kontak', Icons.phone, null),
            _drawerItem(context, 'Tentang Kami', Icons.info, const AboutPage()),
            const Divider(),
            _drawerItem(context, 'Login', Icons.login, const LoginPage()),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar header
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/cs.png',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Judul
                  Text(
                    'Punya Pertanyaan?',
                    style: TextStyle(
                      fontFamily: poppins,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Deskripsi
                  Text(
                    'Temukan jawaban yang kamu butuhkan dari tim Borotara Motors atau hubungi Customer Service kami.',
                    style: TextStyle(
                      fontFamily: poppins,
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol aksi
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.support_agent),
                        label: Text('Customer Service',
                            style: TextStyle(fontFamily: poppins)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[400],
                          foregroundColor: Colors.white,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.forum),
                        label: Text('Komunitas Borotara',
                            style: TextStyle(fontFamily: poppins)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Kartu kontak
                  _contactCard(Icons.email_outlined, 'Email',
                      'support@borotaramotors.com', poppins),
                  const SizedBox(height: 8),
                  _contactCard(Icons.phone_outlined, 'Telepon',
                      '0812-3456-7890', poppins),
                ],
              ),
            ),

            // ⬇️ FOOTER dikeluarin dari Padding biar full width
            Container(
              color: const Color(0xFF1C2434),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.directions_car,
                      color: Colors.orange, size: 32),
                  const SizedBox(height: 6),
                  Text('Borotara Motors Inc.',
                      style: TextStyle(
                          fontFamily: poppins,
                          color: Colors.orange[400],
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Cibaduyut Kidul, Bandung',
                      style:
                          TextStyle(fontFamily: poppins, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text('support@borotaramotors.com',
                      style: TextStyle(
                          fontFamily: poppins, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('© 2025 Borotara Motors',
                      style: TextStyle(
                          fontFamily: poppins,
                          color: Colors.white54,
                          fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer item helper
  Widget _drawerItem(
      BuildContext context, String title, IconData icon, Widget? page) {
    final String poppins = GoogleFonts.poppins().fontFamily ?? '';
    return ListTile(
      leading: Icon(icon, color: Colors.orange[400]),
      title: Text(title,
          style: TextStyle(fontFamily: poppins, fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        if (page != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        }
      },
    );
  }

  // Contact card builder
  Widget _contactCard(
      IconData icon, String title, String subtitle, String poppins) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title,
            style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        subtitle: Text(subtitle,
            style: TextStyle(
                fontFamily: poppins, color: Colors.black54, fontSize: 13)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

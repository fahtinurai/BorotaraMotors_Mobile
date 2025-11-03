import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contact_page.dart';
import 'about_page.dart';
import 'login_page.dart';
import 'service_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            _drawerItem('Home', Icons.home, () => Navigator.pop(context)),
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
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => AboutPage()))),
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
            // Banner section
            Stack(
              children: [
                Image.asset('assets/bghome.png',
                    height: 200, width: double.infinity, fit: BoxFit.cover),
                Container(
                  height: 200,
                  color: Colors.black.withOpacity(0.45),
                ),
                Positioned(
                  left: 20,
                  bottom: 25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang di',
                        style: TextStyle(
                            fontFamily: poppins,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Borotara Motors',
                        style: TextStyle(
                            fontFamily: poppins,
                            color: Colors.orange[400],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Servis cepat & terpercaya untuk kendaraanmu',
                        style: TextStyle(
                            fontFamily: poppins,
                            color: Colors.white70,
                            fontSize: 13),
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),

            // fitur cards (grid biar mobile enak)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _featureCard(Icons.build_circle, 'Bengkel Lengkap',
                      'Servis profesional & terpercaya'),
                  _featureCard(Icons.schedule, 'Reservasi Mudah',
                      'Booking layanan tanpa antre'),
                  _featureCard(Icons.support_agent, 'Customer Service',
                      'Tim siap bantu 24 jam'),
                  _featureCard(Icons.star, 'Rating Pelanggan',
                      'Lihat pengalaman pengguna lain'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Paket Servis
            _sectionTitle('Paket Servis'),
            SizedBox(
              height: 210,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _serviceCard('Paket Bulanan', 'Cocok untuk pemakaian harian',
                      'assets/gambarbulanan.jpg'),
                  _serviceCard(
                      'Paket 3 Bulan',
                      'Perawatan rutin performa maksimal',
                      'assets/gambar3bulan.jpg'),
                  _serviceCard(
                      'Paket 6 Bulan',
                      'Hemat & terjadwal untuk jangka panjang',
                      'assets/gambar6bulan.jpg'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tentang singkat
            _sectionTitle('Tentang Kami'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Borotara Motors membantu kamu merawat mobil tanpa ribet. '
                'Pesan servis, pilih bengkel terpercaya, dan lacak riwayat kendaraanmu dengan mudah.',
                style: TextStyle(fontFamily: poppins, height: 1.5),
              ),
            ),

            const SizedBox(height: 20),

            // Testimonial
            _sectionTitle('Apa Kata Mereka'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _testimonialCard(
                      'Pelayanan cepat dan profesional.', '— Pelanggan A'),
                  _testimonialCard(
                      'Aplikasinya simpel dan informatif.', '— Pelanggan B'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Footer sederhana
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

  // Drawer Item Builder
  Widget _drawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange[400]),
      title: Text(title,
          style: TextStyle(fontFamily: poppins, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  // Section title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: TextStyle(
                fontFamily: poppins,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange[400], size: 36),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: poppins,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const SizedBox(height: 4),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: poppins,
                  color: Colors.black54,
                  fontSize: 11,
                  height: 1.3)),
        ],
      ),
    );
  }

  Widget _serviceCard(String title, String subtitle, String imagePath) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(imagePath,
                  height: 100, width: double.infinity, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontFamily: poppins, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        fontFamily: poppins,
                        fontSize: 12,
                        color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _testimonialCard(String text, String author) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: TextStyle(fontFamily: poppins)),
            const SizedBox(height: 6),
            Text(author,
                style: TextStyle(
                    fontFamily: poppins, fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

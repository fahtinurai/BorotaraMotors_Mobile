import 'package:flutter/material.dart';
import 'contact_page.dart';
import 'about_page.dart';
import 'login_page.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onMenuTap(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        // already home
        break;
      case 1:
        // layanan placeholder
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
    final String poppins = GoogleFonts.poppins().fontFamily ?? '';
    return DefaultTextStyle(
      style: TextStyle(fontFamily: poppins, color: Colors.black),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: const Color(0xFF1C2434),
          elevation: 0,
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
                label: Text(
                  "Login",
                  style: TextStyle(fontFamily: poppins),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Hero / Banner
              SizedBox(
                height: 220,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/bghome.png',
                      fit: BoxFit.cover,
                    ),
                    Container(color: Colors.black.withOpacity(0.45)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Text(
                            'Selamat Datang di',
                            style: TextStyle(
                                fontFamily: poppins,
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Borotara Motors',
                            style: TextStyle(
                                fontFamily: poppins,
                                color: Colors.orange[400],
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Dapatkan kenyamanan bepergian — servis cepat & terpercaya',
                            style: TextStyle(
                                fontFamily: poppins,
                                color: Colors.white70,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // fitur singkat horizontal
              SizedBox(
                height: 110,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _featureCard(
                        icon: Icons.build_circle,
                        title: 'Bengkel Lengkap',
                        subtitle: 'Terpercaya dengan servis profesional',
                        poppins: poppins),
                    _featureCard(
                        icon: Icons.schedule,
                        title: 'Reservasi',
                        subtitle: 'Booking layanan dengan mudah',
                        poppins: poppins),
                    _featureCard(
                        icon: Icons.support_agent,
                        title: 'Customer Service',
                        subtitle: 'Tim kami siap Bantu 24/7',
                        poppins: poppins),
                    _featureCard(
                        icon: Icons.star_rate,
                        title: 'Rating',
                        subtitle: 'Lihat pengalaman pelanggan lain',
                        poppins: poppins),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Paket Servis (horizontal scroll untuk mobile)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Paket Servis',
                      style: TextStyle(
                          fontFamily: poppins,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _serviceCard(
                        title: 'Paket Bulanan',
                        subtitle:
                            'Cocok untuk Anda yang sering pakai mobil setiap hari.',
                        imageUrl: 'assets/gambarbulanan.jpg',
                        poppins: poppins),
                    _serviceCard(
                        title: 'Paket 3 Bulan',
                        subtitle:
                            'Perawatan rutin biar performa kendaraan tetap optimal.',
                        imageUrl: 'assets/gambar3bulan.jpg',
                        poppins: poppins),
                    _serviceCard(
                        title: 'Paket 6 Bulan',
                        subtitle:
                            'Solusi hemat buat servis jangka panjang, lebih efisien & terjadwal.',
                        imageUrl: 'assets/gambar6bulan.jpg',
                        poppins: poppins),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // About / description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final String poppins =
                            GoogleFonts.poppins().fontFamily ?? '';
                        const purple =
                            Color(0xFF6D6EA3); // sesuaikan warna jika perlu

                        const aboutText =
                            'Borotara Motors Inc. adalah platform digital yang membantu ngerawat mobil tanpa ribet. '
                            'Mulai dari pemesanan servis, pemilihan bengkel terpercaya, sampai pelacakan riwayat servis mobil, '
                            'semuanya bisa lo akses dalam satu aplikasi.\n\n'
                            'Kami hadir buat bantu pengemudi tetap tenang di jalan, dengan layanan cepat, transparan, dan bisa diandalkan.';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image.asset('assets/tentang.jpg',
                                  fit: BoxFit.cover, height: 220),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: purple,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                              child: Text(
                                aboutText,
                                style: TextStyle(
                                  fontFamily: poppins,
                                  color: Colors.white,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // langkah singkat
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Mulai Servis Mobil dengan Mudah',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: poppins,
                              color: Colors.black,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Cukup beberapa langkah sederhana buat dapetin servis mobil tanpa ribet.'
                            'Kami bantu dari pemilihan paket sampai mobil Anda siap jalan lagi!',
                            style: TextStyle(
                              fontFamily: poppins,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _stepItem(
                            icon: Icons.list_alt,
                            title: 'Pilih Paket',
                            poppins: poppins),
                        _stepItem(
                            icon: Icons.calendar_month,
                            title: 'Atur Jadwal',
                            poppins: poppins),
                        _stepItem(
                            icon: Icons.location_on,
                            title: 'Datang ke Bengkel',
                            poppins: poppins),
                        _stepItem(
                            icon: Icons.local_shipping,
                            title: 'Siap Jalan',
                            poppins: poppins),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Testimonial (simple vertical cards)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Apa Kata Mereka',
                        style: TextStyle(
                            fontFamily: poppins,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    _testimonialCard(
                        text:
                            'Pelayanan cepat dan profesional. Sangat membantu!',
                        author: '— Pelanggan A',
                        poppins: poppins),
                    const SizedBox(height: 5),
                    _testimonialCard(
                        text: 'Aplikasinya simpel dan informatif.',
                        author: '— Pelanggan B',
                        poppins: poppins),
                  ],
                ),
              ),

              const SizedBox(height: 18), 

              // Footer (mobile)
              _buildFooter(wide: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(String title, int index) {
    final bool isActive = _selectedIndex == index;
    final String poppins = GoogleFonts.poppins().fontFamily ?? '';
    return TextButton(
      onPressed: () => _onMenuTap(index),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: poppins,
          color: isActive ? Colors.orange[400] : Colors.white,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildFooter({required bool wide}) {
    final footerPadding = wide
        ? const EdgeInsets.symmetric(horizontal: 28, vertical: 36)
        : const EdgeInsets.all(18);
    final String poppins = GoogleFonts.poppins().fontFamily ?? '';
    final logo = Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1C2434),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Icon(Icons.directions_car, color: Colors.orange, size: 22),
          ),
        ),
        const SizedBox(width: 10),
        Text('Borotara Motors Inc.',
            style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.bold,
                color: Colors.orange)),
      ],
    );

    final usefulLinks = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Useful Links',
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontFamily: poppins)),
        const SizedBox(height: 8),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
            child: Text(
              'Tentang Kami',
              style: TextStyle(color: Colors.white, fontFamily: poppins),
            )),
        TextButton(
            onPressed: () {},
            child: Text(
              'Layanan',
              style: TextStyle(color: Colors.white, fontFamily: poppins),
            )),
      ],
    );

    final support = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Support',
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontFamily: poppins)),
        const SizedBox(height: 8),
        TextButton(
            onPressed: () {},
            child: Text(
              'Email',
              style: TextStyle(color: Colors.white, fontFamily: poppins),
            )),
        TextButton(
            onPressed: () {},
            child: Text(
              'Telepon',
              style: TextStyle(color: Colors.white, fontFamily: poppins),
            )),
        TextButton(
            onPressed: () {},
            child: Text(
              'FAQ',
              style: TextStyle(color: Colors.white, fontFamily: poppins),
            )),
      ],
    );

    final contact = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Information',
              style: TextStyle(
                  fontFamily: poppins,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text('Cibaduyut Kidul, Kec. Bojongloa Kidul',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontFamily: poppins)),
          const SizedBox(height: 4),
          Text('support@borotaramotors.com',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  fontFamily: poppins)),
          const SizedBox(height: 4),
          Text('0812-3456-7890',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  fontFamily: poppins,
                  color: Colors.white)),
        ],
      ),
    );

    return Container(
      color: const Color(0xFF262D3C),
      padding: footerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          logo,
          const SizedBox(height: 12),
          Text(
              'Solusi servis mobil modern — cepat, transparan, dan terpercaya.',
              style: TextStyle(fontFamily: poppins, color: Colors.white)),
          const SizedBox(height: 12),
          usefulLinks,
          support,
          contact,
        ],
      ),
    );
  }

  Widget _featureCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      required String poppins}) {
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      child: Row(
        children: [
          Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: Colors.orange[400])),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontFamily: poppins, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          fontFamily: poppins,
                          color: Colors.black54,
                          fontSize: 12)),
                ]),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard(
      {required String title,
      required String subtitle,
      required String imageUrl,
      required String poppins}) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(imageUrl, height: 96, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: TextStyle(
                      fontFamily: poppins, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(subtitle,
                  style: TextStyle(
                      fontFamily: poppins,
                      color: Colors.black54,
                      fontSize: 12)),
            ]),
          )
        ],
      ),
    );
  }

  Widget _stepItem(
      {required IconData icon,
      required String title,
      required String poppins}) {
    return Expanded(
      child: Column(
        children: [
          Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: Colors.orange[400])),
          const SizedBox(height: 6),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: poppins, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _testimonialCard(
      {required String text, required String author, required String poppins}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(text, style: TextStyle(fontFamily: poppins)),
          const SizedBox(height: 8),
          Text(author,
              style: TextStyle(
                  fontFamily: poppins, fontSize: 12, color: Colors.black54)),
        ]),
      ),
    );
  }
}

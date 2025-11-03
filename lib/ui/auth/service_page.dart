import 'package:borotara_project/ui/auth/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contact_page.dart'; // Asumsi file ini ada
import 'about_page.dart'; // Asumsi file ini ada
import 'login_page.dart'; // Asumsi file ini ada
// import 'home_page.dart'; // Anda mungkin perlu ini untuk navigasi kembali

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  // --- State & Variabel ---

  // Mengambil font Poppins, sama seperti di HomePage
  final String poppins = GoogleFonts.poppins().fontFamily ?? '';

  // Warna utama dari 'vibe' HomePage
  final Color darkColor = const Color(0xFF1C2434);
  final Color orangeColor = Colors.orange[400]!;

  // Warna spesifik dari gambar untuk form pemesanan
  final Color formBgColor = const Color(0xFF4B5378);

  // State untuk mengelola tab brand mobil yang dipilih
  int _selectedBrand = 0;
  final List<String> _brands = ['Daihatsu', 'Toyota', 'Suzuki', 'Nissan'];

  // --- Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // 1. APPBAR: Menggunakan gaya yang sama persis dari HomePage
      appBar: AppBar(
        backgroundColor: darkColor,
        title: Text(
          "Borotara Motors",
          style: TextStyle(
            fontFamily: poppins,
            color: orangeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: orangeColor), // Agar ikon drawer oranye
      ),
      // 2. DRAWER: Menggunakan gaya yang sama persis dari HomePage
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: darkColor),
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
            _drawerItem('Home', Icons.home,
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HomePage()))),
            _drawerItem('Layanan', Icons.build_circle, () {
              // Sudah di halaman layanan
            }),
            _drawerItem(
                'Kontak',
                Icons.phone,
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ContactPage()))), // Ganti halaman
            _drawerItem(
                'Tentang Kami',
                Icons.info,
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AboutPage()))), // Ganti halaman
            const Divider(),
            _drawerItem(
                'Login',
                Icons.login,
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LoginPage()))), // Ganti halaman
          ],
        ),
      ),
      // 3. BODY: Layout dari gambar
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBannerSection(),
            _buildServicePackageSection(),
            const SizedBox(height: 100), // Spasi sebelum footer
            _buildFooter(), // Mengganti form dengan footer
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets (Style dari HomePage) ---

  Widget _drawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: orangeColor),
      title: Text(title,
          style: TextStyle(fontFamily: poppins, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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

  // --- Widget Spesifik untuk Halaman Ini (Layout dari Gambar) ---

  // 1. Banner Section (dari gambar)
  Widget _buildBannerSection() {
    return Stack(
      children: [
        // Asumsi Anda punya gambar banner di assets
        Image.asset(
          'assets/bghome.png', // Ganti dengan path gambar banner Anda
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          // Fallback jika gambar tidak ada
          errorBuilder: (ctx, err, stack) => Container(
            height: 180,
            color: Colors.grey[300],
            child: Icon(Icons.build, size: 50, color: Colors.grey[600]),
          ),
        ),
        Container(
          height: 180,
          color: Colors.black.withOpacity(0.50), // Overlay gelap
        ),
        Positioned(
          left: 20,
          bottom: 20,
          right: 20, // Tambahkan right padding agar teks tidak mentok
          child: Text(
            'Percayakan perawatan mobil Anda pada Teknisi Berpengalaman kami',
            style: TextStyle(
                fontFamily: poppins,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.4),
          ),
        )
      ],
    );
  }

  // 2. Paket Servis Section (dari gambar)
  Widget _buildServicePackageSection() {
    return Container(
      color: Colors.white, // Latar belakang putih seperti di gambar
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          _sectionTitle('Paket Servis'), // Menggunakan helper dari HomePage
          const SizedBox(height: 12),
          // Tab Bar (Daihatsu, Toyota, dst.)
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _brands.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedBrand == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBrand = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      // Warna dari gambar (Selected: biru tua, Unselected: transparan)
                      color: isSelected ? formBgColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _brands[index],
                      style: TextStyle(
                        fontFamily: poppins,
                        color: isSelected ? Colors.white : Colors.black54,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Service Cards (Gran Max, Luxio)
          SizedBox(
            height: 220, // Tinggi card
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Anda bisa buat logic di sini untuk menampilkan card
                // berdasarkan _selectedBrand
                // Untuk saat ini, saya hardcode sesuai gambar:
                if (_selectedBrand == 0) ...[
                  _buildImageServiceCard(
                      'assets/granmax.png', // Ganti path gambar
                      'Paket Servis Gran Max',
                      'Rp. 1.800.000,00'),
                  _buildImageServiceCard(
                      'assets/luxio.png', // Ganti path gambar
                      'Paket Servis Luxio',
                      'Rp. 1.540.000,00'),
                ] else ...[
                  // Tampilkan paket untuk brand lain
                  Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: Text(
                      'Paket untuk ${_brands[_selectedBrand]}',
                      style: TextStyle(fontFamily: poppins, color: Colors.grey),
                    ),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk card servis (style dari gambar)
  Widget _buildImageServiceCard(String imagePath, String title, String price) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50], // Latar belakang card abu-abu muda
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 110,
              width: 160,
              fit: BoxFit.contain, // Agar gambar mobil terlihat utuh
              // Fallback jika gambar tidak ada
              errorBuilder: (ctx, err, stack) => Container(
                  height: 110,
                  width: 160,
                  color: Colors.grey[200],
                  child: Icon(Icons.directions_car,
                      size: 40, color: Colors.grey[400])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 2,
                    style: TextStyle(
                        fontFamily: poppins,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                const SizedBox(height: 4),
                Text('Harga Mulai',
                    style: TextStyle(
                        fontFamily: poppins, fontSize: 11, color: Colors.black54)),
                const SizedBox(height: 2),
                Text(price,
                    style: TextStyle(
                        fontFamily: poppins,
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Footer
  Widget _buildFooter() {
    return Container(
      color: const Color(0xFF1C2434), // darkColor
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.directions_car, color: Colors.orange, size: 32),
          const SizedBox(height: 6),
          Text('Borotara Motors Inc.',
              style: TextStyle(
                  fontFamily: poppins,
                  color: orangeColor,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Cibaduyut Kidul, Bandung',
              style: TextStyle(fontFamily: poppins, color: Colors.white)),
          const SizedBox(height: 2),
          Text('support@borotaramotors.com',
              style: TextStyle(fontFamily: poppins, color: Colors.white70)),
          const SizedBox(height: 8),
          Text('© 2025 Borotara Motors',
              style: TextStyle(
                  fontFamily: poppins,
                  color: Colors.white54,
                  fontSize: 12)),
        ],
      ),
    );
  }
}
// ...existing code...
import 'package:flutter/material.dart';
import 'about_page.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int _selectedIndex = 2; // Contact aktif

  void _onMenuTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
        // Layanan belum ada, bisa tambahkan nanti
        break;
      case 2:
        // Already on contact page
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
    // common poppins family shortcut
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool wide = constraints.maxWidth >= 700;
            final Widget image = ClipRRect(
                child: Image.asset(
                'assets/cs.png',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                ),
            );

            final Widget content = Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Punya Pertanyaan?',
                    style: TextStyle(
                      fontFamily: poppins,
                      fontSize: wide ? 40 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ini adalah tempat untuk memulai. Temukan jawaban yang Anda butuhkan dari komunitas Borotara Motors atau CS kami.',
                    style: TextStyle(
                      fontFamily: poppins,
                      fontSize: wide ? 16 : 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      TextButton(
                        onPressed: () {
                          // bisa ditambah navigasi ke halaman Customer Service
                        },
                        child: Text('Customer Service',
                            style: TextStyle(fontFamily: poppins)),
                      ),
                      TextButton(
                        onPressed: () {
                          // bisa ditambah navigasi ke komunitas
                        },
                        child: Text('Komunitas Borotara',
                            style: TextStyle(fontFamily: poppins)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // contact quick info card
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.email_outlined,
                              color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email',
                                    style: TextStyle(
                                        fontFamily: poppins,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('support@borotaramotors.com',
                                    style: TextStyle(
                                        fontFamily: poppins,
                                        color: Colors.black54)),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // bisa ditambah action untuk buka email
                            },
                            icon: const Icon(Icons.chevron_right),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.phone_outlined,
                              color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Telepon',
                                    style: TextStyle(
                                        fontFamily: poppins,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('0812-3456-7890',
                                    style: TextStyle(
                                        fontFamily: poppins,
                                        color: Colors.black54)),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // TODO: action to make call
                            },
                            icon: const Icon(Icons.chevron_right),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );

            if (wide) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: content),
                          const SizedBox(width: 16),
                          Expanded(flex: 5, child: image),
                        ],
                      ),
                    ),
                    _buildFooter(wide: true),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    image,
                    content,
                    const SizedBox(height: 20),
                    _buildFooter(wide: false),
                  ],
                ),
              );
            }
          },
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
}
// ...existing code...

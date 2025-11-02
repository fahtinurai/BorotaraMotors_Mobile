import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2434),
        title: const Text(
          "Borotara Motors",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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

                  // Kotak Visi dan Misi
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isWide = constraints.maxWidth > 700;
                      return Flex(
                        direction: isWide ? Axis.horizontal : Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Visi
                          Expanded(
                            child: Container(
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
                            ),
                          ),

                          // Misi
                          Expanded(
                            child: Container(
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
                            ),
                          ),
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
}

// lib/ui/driver/driver_profile_page.dart
import 'package:flutter/material.dart';
import 'package:borotara_project/app_colors.dart';
import 'package:borotara_project/services/local_storage_service.dart';
import 'package:borotara_project/ui/auth/login_page.dart';

class DriverProfilePage extends StatelessWidget {
  final String username;
  final String userKey;

  const DriverProfilePage({
    super.key,
    required this.username,
    required this.userKey,
  });

  Future<void> _logout(BuildContext context) async {
    // pakai cara baru: cuma hapus session
    await LocalStorageService.clear();

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout berhasil')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: Colors.white, size: 60),
            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'User Key: $userKey',
              style: const TextStyle(color: AppColors.textDim),
            ),
            const Divider(height: 40),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Aplikasi'),
              subtitle: Text('Borotara Motors Mobile'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

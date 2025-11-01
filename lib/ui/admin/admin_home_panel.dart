// lib/ui/admin/admin_home_panel.dart
import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../controllers/admin_controller.dart';
import '../../services/local_storage_service.dart';
import '../auth/login_page.dart';

class AdminHomePanel extends StatefulWidget {
  final AdminController controller;
  final VoidCallback? onOpenFollowUp; // <<– tambahan

  const AdminHomePanel({
    super.key,
    required this.controller,
    this.onOpenFollowUp,
  });

  @override
  State<AdminHomePanel> createState() => _AdminHomePanelState();
}

class _AdminHomePanelState extends State<AdminHomePanel> {
  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    return RefreshIndicator(
      onRefresh: () async {
        await c.refreshFollowUp();
        setState(() {});
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // ===== TITLE =====
          const Text(
            'Dashboard Admin',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ===== STAT CARDS =====
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              const SizedBox.shrink(),
              _StatCard(
                title: 'Total User Key',
                value: c.userKeys.length.toString(),
                subtitle: 'Admin, Driver, Teknisi',
              ),
              _StatCard(
                title: 'Total Kendaraan',
                value: c.vehicles.length.toString(),
                subtitle: 'Data kendaraan tersimpan',
              ),
              _StatCard(
                title: 'Total Assign',
                value: c.driverVehicles.length.toString(),
                subtitle: 'Driver telah assign',
              ),
              // ⬇⬇ ini yang bisa diklik
              _StatCard(
                title: 'Butuh Follow Up',
                value: c.followUpCount.toString(),
                subtitle: 'Laporan teknisi',
                onTap: widget.onOpenFollowUp,   // <<– panggil ke atas
                highlight: true,
              ),
            ]..removeAt(0),
          ),
          const SizedBox(height: 24),

          // ===== NOTIFIKASI =====
          const Text(
            'Notifikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Card(
            color: AppColors.bgCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Teknisi dengan status follow-up'),
              subtitle: Text(
                '${c.followUpCount} laporan memerlukan tindak lanjut.',
              ),
              onTap: widget.onOpenFollowUp, // ← card ini juga bisa klik
            ),
          ),

          const SizedBox(height: 28),

          // ===== LOGOUT BUTTON (PALING BAWAH) =====
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Yakin ingin keluar dari aplikasi?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  // pastikan service siap
                  final svc = LocalStorageService();
                  await svc.init();
                  await LocalStorageService.clear();

                  if (!mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback? onTap;
  final bool highlight;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight
              ? Colors.red.withOpacity(0.4)
              : AppColors.primary.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: highlight ? Colors.red : AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textDim,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: card,
    );
  }
}

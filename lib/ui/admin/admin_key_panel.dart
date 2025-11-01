// lib/ui/admin/admin_key_panel.dart
import 'package:flutter/material.dart';
import '../../controllers/admin_controller.dart';
import '../../app_colors.dart';
import '../../services/local_storage_service.dart'; // 👈 tambah ini

class AdminKeyPanel extends StatefulWidget {
  final AdminController controller;
  const AdminKeyPanel({super.key, required this.controller});

  @override
  State<AdminKeyPanel> createState() => _AdminKeyPanelState();
}

class _AdminKeyPanelState extends State<AdminKeyPanel> {
  final usernameCtrl = TextEditingController();
  final keyCtrl = TextEditingController();
  String selectedRole = 'driver';

  @override
  void dispose() {
    usernameCtrl.dispose();
    keyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final isSmall = MediaQuery.of(context).size.width < 520;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text(
            'Buat Key User',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 🔹 Input form
          if (isSmall)
            Column(
              children: [
                TextField(
                  controller: usernameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Username / Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    DropdownMenuItem(value: 'driver', child: Text('Driver')),
                    DropdownMenuItem(value: 'teknisi', child: Text('Teknisi')),
                  ],
                  onChanged: (v) => setState(() => selectedRole = v ?? 'driver'),
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: keyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Key / Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                    onPressed: () async {
                      final user = usernameCtrl.text.trim();
                      final key = keyCtrl.text.trim();
                      if (user.isEmpty || key.isEmpty) return;

                      // 1) simpan ke controller (biar tabel kebaru)
                      await c.addUserKey(
                        username: user,
                        role: selectedRole,
                        key: key,
                      );

                      // 2) simpan ke storage login (biar bisa dipakai di layar login)
                      final svc = LocalStorageService();
                      await svc.init();
                      await svc.addOrUpdateUser({
                        'role': selectedRole,
                        'username': user,
                        'key': key,
                      });

                      usernameCtrl.clear();
                      keyCtrl.clear();
                      setState(() {});
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User berhasil ditambahkan!'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: usernameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Username / Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    items: const [
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      DropdownMenuItem(value: 'driver', child: Text('Driver')),
                      DropdownMenuItem(value: 'teknisi', child: Text('Teknisi')),
                    ],
                    onChanged: (v) => setState(() => selectedRole = v ?? 'driver'),
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: keyCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Key / Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                  onPressed: () async {
                    final user = usernameCtrl.text.trim();
                    final key = keyCtrl.text.trim();
                    if (user.isEmpty || key.isEmpty) return;

                    // 1) update controller
                    await c.addUserKey(
                      username: user,
                      role: selectedRole,
                      key: key,
                    );

                    // 2) update storage login
                    final svc = LocalStorageService();
                    await svc.init();
                    await svc.addOrUpdateUser({
                      'role': selectedRole,
                      'username': user,
                      'key': key,
                    });

                    usernameCtrl.clear();
                    keyCtrl.clear();
                    setState(() {});
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User berhasil ditambahkan!'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          const Text(
            'Daftar User Key',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          Card(
            color: AppColors.bgCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Key')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: List.generate(c.userKeys.length, (i) {
                  final u = c.userKeys[i];
                  return DataRow(
                    cells: [
                      DataCell(Text('${i + 1}')),
                      DataCell(Text(u['username'] ?? '-')),
                      DataCell(Text(u['role'] ?? '-')),
                      DataCell(Text(u['key'] ?? '-')),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await c.deleteUserKey(u['username']);
                            setState(() {});
                            // kalau mau sekalian hapus dari LocalStorageService
                            final svc = LocalStorageService();
                            await svc.init();
                            // ambil semua, hapus yang ini, simpan lagi
                            final all = await svc.getAllUsers();
                            all.removeWhere((x) =>
                                x['username'] == u['username'] &&
                                x['role'] == u['role']);
                            // simpan ulang
                            // (boleh kita bikin method baru di service, tapi ini cukup)
                            await svc.addOrUpdateUser; // <- bisa dibuat ulang kalau mau
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/ui/admin/admin_assign_panel.dart
import 'package:flutter/material.dart';
import '../../controllers/admin_controller.dart';
import '../../app_colors.dart';

class AdminAssignPanel extends StatefulWidget {
  final AdminController controller;
  const AdminAssignPanel({super.key, required this.controller});

  @override
  State<AdminAssignPanel> createState() => _AdminAssignPanelState();
}

class _AdminAssignPanelState extends State<AdminAssignPanel> {
  String? selectedDriver;
  String? selectedPlate;

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    // ambil hanya user yang rolenya driver
    final drivers = c.userKeys.where((u) => u['role'] == 'driver').toList();
    // ambil semua kendaraan
    final vehicles = c.vehicles;

    final isSmall = MediaQuery.of(context).size.width < 520;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text(
            'Assign Kendaraan ke Driver',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 🔹 Form assign (versi mobile & versi lebar)
          if (isSmall)
            Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedDriver,
                  items: drivers
                      .map(
                        (u) => DropdownMenuItem<String>(
                          value: u['username'] as String,
                          child: Text(u['username'] as String),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => selectedDriver = v),
                  decoration: const InputDecoration(
                    labelText: 'Pilih Driver',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedPlate,
                  items: vehicles
                      .map(
                        (v) => DropdownMenuItem<String>(
                          value: v['plate'] as String,
                          child: Text('${v['brand']} - ${v['plate']}'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => selectedPlate = v),
                  decoration: const InputDecoration(
                    labelText: 'Pilih Kendaraan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Assign'),
                    onPressed: () async {
                      await _onAssign(context, c);
                    },
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                // pilih driver
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedDriver,
                    items: drivers
                        .map(
                          (u) => DropdownMenuItem<String>(
                            value: u['username'] as String,
                            child: Text(u['username'] as String),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedDriver = v),
                    decoration: const InputDecoration(
                      labelText: 'Pilih Driver',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // pilih kendaraan
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedPlate,
                    items: vehicles
                        .map(
                          (v) => DropdownMenuItem<String>(
                            value: v['plate'] as String,
                            child: Text('${v['brand']} - ${v['plate']}'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedPlate = v),
                    decoration: const InputDecoration(
                      labelText: 'Pilih Kendaraan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // tombol Assign
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Assign'),
                  onPressed: () async {
                    await _onAssign(context, c);
                  },
                ),
              ],
            ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          const Text(
            'Daftar Assign Kendaraan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          Card(
            // kalau di app_colors.dart kamu ada bgCard, ganti baris ini jadi AppColors.bgCard
            color: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Driver')),
                  DataColumn(label: Text('Kendaraan')),
                  DataColumn(label: Text('Plat')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: _buildAssignRows(c),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onAssign(BuildContext context, AdminController c) async {
    if (selectedDriver == null || selectedPlate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih driver dan kendaraan dulu'),
        ),
      );
      return;
    }

    // pakai controller terbaru → bisa balikin error
    final err = await c.assignVehicle(
      driverUsername: selectedDriver!,
      plate: selectedPlate!,
    );

    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
      return;
    }

    setState(() {});
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kendaraan berhasil di-assign ke driver!'),
        ),
      );
    }
  }

  List<DataRow> _buildAssignRows(AdminController c) {
    final List<DataRow> rows = [];
    int counter = 1;

    for (final dv in c.driverVehicles) {
      final String username = dv['username'] ?? '-';
      final List vehicles = dv['vehicles'] ?? [];

      for (final v in vehicles) {
        rows.add(
          DataRow(
            cells: [
              DataCell(Text('${counter++}')),
              DataCell(Text(username)),
              DataCell(Text(v['brand'] ?? '-')),
              DataCell(Text(v['plate'] ?? '-')),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await c.deleteAssign(
                      driverUsername: username,
                      plate: v['plate'],
                    );
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        );
      }
    }

    return rows;
  }
}

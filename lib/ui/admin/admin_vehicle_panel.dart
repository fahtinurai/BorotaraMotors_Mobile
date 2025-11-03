// lib/ui/admin/admin_vehicle_panel.dart
import 'package:flutter/material.dart';
import '../../controllers/admin_controller.dart';
import '../../app_colors.dart';

class AdminVehiclePanel extends StatefulWidget {
  final AdminController controller;
  const AdminVehiclePanel({super.key, required this.controller});

  @override
  State<AdminVehiclePanel> createState() => _AdminVehiclePanelState();
}

class _AdminVehiclePanelState extends State<AdminVehiclePanel> {
  final brandCtrl = TextEditingController();
  final plateCtrl = TextEditingController();

  @override
  void dispose() {
    brandCtrl.dispose();
    plateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final isSmall = MediaQuery.of(context).size.width < 850;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text(
            'Tambah Data Kendaraan',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // 🔹 Form tambah kendaraan
          if (isSmall)
            Column(
              children: [
                TextField(
                  controller: brandCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Merk Kendaraan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: plateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Polisi (Plat)',
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
                      await _onAdd(context, c);
                    },
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  flex: 3, 
                  child: TextField(
                    controller: brandCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Merk Kendaraan',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: plateCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Polisi (Plat)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2, 
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    onPressed: () async {
                      await _onAdd(context, c);
                    },
                  ),
                ),
              ],
            ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          const Text(
            'Daftar Kendaraan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          Card(
            color: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Merk')),
                    DataColumn(label: Text('Plat')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List.generate(c.vehicles.length, (i) {
                    final v = c.vehicles[i];
                    return DataRow(
                      cells: [
                        DataCell(Text('${i + 1}')),
                        DataCell(Text(v['brand'] ?? '-')),
                        DataCell(Text(v['plate'] ?? '-')),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await c.deleteVehicle(v['plate']);
                              setState(() {});
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Kendaraan dihapus'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onAdd(BuildContext context, AdminController c) async {
    final brand = brandCtrl.text.trim();
    final plate = plateCtrl.text.trim();
    if (brand.isEmpty || plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Merk dan plat tidak boleh kosong'),
        ),
      );
      return;
    }

    final err = await c.addVehicle(brand: brand, plate: plate);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
      return;
    }

    brandCtrl.clear();
    plateCtrl.clear();
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kendaraan berhasil ditambahkan')),
      );
    }
  }
}
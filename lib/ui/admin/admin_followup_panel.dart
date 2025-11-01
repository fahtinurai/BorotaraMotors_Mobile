// lib/ui/admin/admin_followup_panel.dart
import 'package:flutter/material.dart';
import '../../controllers/admin_controller.dart';
import '../../services/repair_queue_service.dart';
import '../../app_colors.dart'; // kalau kamu taruh di sini

class AdminFollowUpPanel extends StatefulWidget {
  final AdminController controller;
  const AdminFollowUpPanel({super.key, required this.controller});

  @override
  State<AdminFollowUpPanel> createState() => _AdminFollowUpPanelState();
}

class _AdminFollowUpPanelState extends State<AdminFollowUpPanel> {
  List<Map<String, dynamic>> tickets = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await RepairQueueService.getNeedFollowUp();
    if (!mounted) return;
    setState(() {
      tickets = data;
      loading = false;
    });
    await widget.controller.refreshFollowUp();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Follow Up Teknisi',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Total tiket yang perlu ditindaklanjuti: ${widget.controller.followUpCount}',
            style: const TextStyle(color: AppColors.secondary),
          ),
          const SizedBox(height: 16),

          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (tickets.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Tidak ada tiket yang butuh follow up 👍'),
              ),
            )
          else
            Card(
              // kalau di app_colors.dart kamu ada bgCard, ganti ke AppColors.bgCard
              color: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Plat')),
                    DataColumn(label: Text('Brand')),
                    DataColumn(label: Text('Keluhan')),
                    DataColumn(label: Text('Catatan Driver')),
                    DataColumn(label: Text('Catatan Teknisi')),
                    DataColumn(label: Text('Driver')),
                    DataColumn(label: Text('Update Terakhir')),
                  ],
                  rows: List.generate(tickets.length, (i) {
                    final t = tickets[i];
                    return DataRow(
                      cells: [
                        DataCell(Text('${i + 1}')),
                        DataCell(Text(t['plate'] ?? '-')),
                        DataCell(Text(t['brand'] ?? '-')),
                        DataCell(Text(t['issue'] ?? '-')),
                        DataCell(Text(
                          t['driverExtraNeeds'] ?? t['note'] ?? '-',
                        )),
                        DataCell(Text(t['techNote'] ?? '-')),
                        DataCell(Text(t['driverUsername'] ?? '-')),
                        DataCell(
                          Text(
                            _formatDate(t['lastUpdate']),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              await _load();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data follow up diperbarui')),
                );
              }
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic raw) {
    if (raw == null) return '-';
    final s = raw.toString();
    // contoh format dari backend: 2025-10-31T12:10:30.000Z
    if (s.contains('T')) {
      return s.replaceFirst('T', ' ').split('.').first;
    }
    return s;
  }
}
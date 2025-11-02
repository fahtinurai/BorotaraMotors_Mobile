import 'package:flutter/material.dart';
import '../shared/responsive_scaffold.dart';
import '/services/repair_queue_service.dart';
import '/services/local_storage_service.dart';
import '/ui/auth/login_page.dart';

class TeknisiDashboardPage extends StatefulWidget {
  const TeknisiDashboardPage({super.key});

  @override
  State<TeknisiDashboardPage> createState() => _TeknisiDashboardPageState();
}

class _TeknisiDashboardPageState extends State<TeknisiDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  List<Map<String, dynamic>> _tickets = [];
  Map<String, dynamic>? _selected;
  bool _loading = true;

  final TextEditingController _techNoteCtrl = TextEditingController();

  // daftar status yang boleh muncul di dropdown
  static const List<String> _allowedStatuses = [
    'menunggu',
    'proses',
    'selesai',
    'followup',
  ];

  String _status = 'proses';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() => _loading = true);
    try {
      final data = await RepairQueueService.getAll();
      setState(() {
        _tickets = data;
        if (_tickets.isNotEmpty) {
          _selected = _tickets.first;

          _techNoteCtrl.text = _selected!['techNote'] ?? '';
          final rawStatus = _selected!['statusTeknisi']?.toString() ?? 'proses';

          // kalau status dari storage bukan salah satu dari 4 ini, paksa ke 'proses'
          _status = _allowedStatuses.contains(rawStatus) ? rawStatus : 'proses';
        }
      });
    } catch (e) {
      debugPrint('error load tickets: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    _techNoteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveMobileScaffold(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Panel Teknisi'),
          bottom: TabBar(
            controller: _tab,
            tabs: const [
              Tab(text: 'Daftar'),
              Tab(text: 'Detail'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: _loadTickets,
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: TabBarView(
          controller: _tab,
          children: [
            _buildListTab(),
            _buildDetailTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildListTab() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_tickets.isEmpty) {
      return const Center(child: Text('Belum ada pekerjaan.'));
    }
    return ListView.builder(
      itemCount: _tickets.length,
      itemBuilder: (context, index) {
        final t = _tickets[index];
        final status = t['statusTeknisi'] ?? 'menunggu';
        return ListTile(
          title: Text(t['plate'] ?? '-'),
          subtitle: Text(t['issue'] ?? '-'),
          trailing: _StatusChip(
            status: _allowedStatuses.contains(status) ? status : 'menunggu',
          ),
          onTap: () {
            setState(() {
              _selected = t;
              _techNoteCtrl.text = t['techNote'] ?? '';
              final rawStatus = t['statusTeknisi']?.toString() ?? 'proses';
              _status =
                  _allowedStatuses.contains(rawStatus) ? rawStatus : 'proses';
              _tab.animateTo(1);
            });
          },
        );
      },
    );
  }

  Widget _buildDetailTab() {
    if (_selected == null) {
      return const Center(child: Text('Pilih pekerjaan dulu.'));
    }

    final t = _selected!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Laporan ${t['plate'] ?? '-'}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text('Driver: ${t['driverUsername'] ?? '-'}'),
          const SizedBox(height: 10),
          _InfoRow(label: 'Merk', value: t['brand'] ?? '-'),
          _InfoRow(label: 'Keluhan', value: t['issue'] ?? '-'),
          _InfoRow(
            label: 'Catatan Driver',
            value: t['driverExtraNeeds'] ?? t['note'] ?? '-',
          ),
          const SizedBox(height: 16),
          const Text('Catatan Teknisi'),
          const SizedBox(height: 4),
          TextField(
            controller: _techNoteCtrl,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Status Perbaikan'),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            initialValue: _allowedStatuses.contains(_status) ? _status : 'proses',
            items: const [
              DropdownMenuItem(value: 'menunggu', child: Text('Menunggu')),
              DropdownMenuItem(value: 'proses', child: Text('Proses')),
              DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
              DropdownMenuItem(value: 'followup', child: Text('Butuh Follow Up')),
            ],
            onChanged: (val) {
              if (val == null) return;
              setState(() => _status = val);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _onSave,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Update'),
            ),
          ),
          const SizedBox(height: 16),
          // tombol logout di bawah
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave() async {
    if (_selected == null) return;
    final plate = (_selected!['plate'] ?? '').toString();
    if (plate.isEmpty) return;

    try {
      await RepairQueueService.updateFromTeknisi(
        plate: plate,
        techNote: _techNoteCtrl.text,
        status: _status,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil diupdate')),
        );
      }
      _loadTickets();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update: $e')),
        );
      }
    }
  }

  Future<void> _onLogout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout teknisi'),
        content: const Text('Yakin mau keluar?'),
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

    if (ok != true) return;

    await LocalStorageService.clear();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label)),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  Color _color() {
    switch (status) {
      case 'selesai':
        return Colors.green;
      case 'proses':
        return Colors.orange;
      case 'followup':
        return Colors.red;
      case 'menunggu':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _color();
    return Chip(
      label: Text(status),
      backgroundColor: c.withOpacity(.1),
      labelStyle: TextStyle(color: c),
    );
  }
}

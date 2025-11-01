import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/repair_queue_service.dart';
import 'driver_profile_page.dart';

class DriverDashboardPage extends StatefulWidget {
  final String username;
  final String userKey;

  const DriverDashboardPage({
    super.key,
    required this.username,
    required this.userKey,
  });

  @override
  State<DriverDashboardPage> createState() => _DriverDashboardPageState();
}

class _DriverDashboardPageState extends State<DriverDashboardPage> {
  int _selectedIndex = 0;

  final _plateCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _issueCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  List<Map<String, dynamic>> _reports = [];
  List<Map<String, dynamic>> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
    _loadMyVehicles();
  }

  // ================== LOAD DATA ==================

  /// ambil semua laporan lalu filter punyaku
  Future<void> _loadReports() async {
    final all = await RepairQueueService.getAll();
    setState(() {
      _reports = all
          .where((r) =>
              (r['driverUsername'] ?? '').toString().toLowerCase() ==
              widget.username.toLowerCase())
          .toList();
    });
  }

  /// ambil kendaraan yang sudah di-assign admin
  Future<void> _loadMyVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('driverVehicles');
    if (raw == null) return;

    final List decoded = jsonDecode(raw);
    final me = decoded.firstWhere(
      (e) =>
          (e['username'] as String).toLowerCase() ==
          widget.username.toLowerCase(),
      orElse: () => <String, dynamic>{},
    );
    if (me.isEmpty) return;

    setState(() {
      _vehicles = List<Map<String, dynamic>>.from(me['vehicles'] ?? []);
    });
  }

  // ================== DRIVER KIRIM LAPORAN ==================

  Future<void> _addReport() async {
    if (_plateCtrl.text.isEmpty || _issueCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plat dan kerusakan wajib diisi')),
      );
      return;
    }

    final noteText = _noteCtrl.text.trim();

    // kirim ke service (yang sekarang menjaga status teknisi)
    await RepairQueueService.upsertFromDriver(
      plate: _plateCtrl.text.trim(),
      brand: _brandCtrl.text.trim(),
      issue: _issueCtrl.text.trim(),
      note: noteText,
      driverUsername: widget.username,
      driverExtraNeeds: noteText,
    );

    await _loadReports();

    _plateCtrl.clear();
    _brandCtrl.clear();
    _issueCtrl.clear();
    _noteCtrl.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Laporan berhasil dikirim')),
    );
    setState(() => _selectedIndex = 0);
  }

  // ================== PANEL HOME ==================

  Widget _buildHomePanel() {
    final total = _reports.length;

    final now = DateTime.now();
    final totalBulan = _reports.where((r) {
      final lu = r['lastUpdate'];
      if (lu == null) return false;
      try {
        final d = DateTime.parse(lu.toString());
        return d.month == now.month && d.year == now.year;
      } catch (_) {
        return false;
      }
    }).length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(widget.username[0].toUpperCase()),
              ),
              title: Text("Selamat Datang, ${widget.username}!"),
              subtitle: Text("Key: ${widget.userKey}"),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadReports,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          "$totalBulan",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("Laporan Bulan Ini"),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  color: Colors.indigo.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          "$total",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text("Total Laporan"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Tambah Laporan"),
            onPressed: () => setState(() => _selectedIndex = 1),
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildReportTable()),
        ],
      ),
    );
  }

  // ================== FORM TAMBAH LAPORAN ==================

  Widget _buildFormPanel() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadMyVehicles().then((_) => _vehicles),
      builder: (context, snapshot) {
        final data = snapshot.data ?? _vehicles;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Tambah Laporan Kerusakan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (data.isNotEmpty)
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Pilih Kendaraan",
                      border: OutlineInputBorder(),
                    ),
                    items: data
                        .map(
                          (v) => DropdownMenuItem<String>(
                            value: v['plate'] as String,
                            child: Text("${v['brand']} - ${v['plate']}"),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      final picked = data.firstWhere(
                        (v) => v['plate'] == val,
                        orElse: () => <String, dynamic>{},
                      );
                      if (picked.isNotEmpty) {
                        _plateCtrl.text = picked['plate'];
                        _brandCtrl.text = picked['brand'];
                      }
                    },
                  ),
                const SizedBox(height: 10),
                TextField(
                  controller: _plateCtrl,
                  decoration: const InputDecoration(
                    labelText: "Plat Nomor",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _brandCtrl,
                  decoration: const InputDecoration(
                    labelText: "Merek",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _issueCtrl,
                  decoration: const InputDecoration(
                    labelText: "Kerusakan",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(
                    labelText: "Catatan / Deskripsi",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text("Kirim Laporan"),
                    onPressed: _addReport,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================== LIST LAPORAN ==================

  Widget _buildReportTable() {
    if (_reports.isEmpty) {
      return const Center(child: Text("Belum ada laporan"));
    }

    return RefreshIndicator(
      onRefresh: _loadReports,
      child: ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, i) {
          final r = _reports[i];
          final status = (r['statusTeknisi'] ?? r['status'] ?? 'menunggu')
              .toString()
              .toLowerCase();
          final note =
              r['techNote'] ?? r['driverExtraNeeds'] ?? r['note'] ?? '-';

          Color? bg;
          if (status == 'selesai') {
            bg = Colors.green.shade50;
          } else if (status == 'followup') {
            bg = Colors.orange.shade50;
          }

          return Card(
            color: bg,
            child: ListTile(
              title: Text("${r['brand']} - ${r['plate']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Kerusakan: ${r['issue']}"),
                  Text("Catatan: $note"),
                  Text("Status: $status"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================== LIFECYCLE ==================

  @override
  void dispose() {
    _plateCtrl.dispose();
    _brandCtrl.dispose();
    _issueCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  // ================== BUILD ==================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Dashboard"),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReports,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePanel(),
          _buildFormPanel(),
          DriverProfilePage(
            username: widget.username,
            userKey: widget.userKey,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Laporan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

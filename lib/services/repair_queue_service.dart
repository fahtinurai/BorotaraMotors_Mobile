// lib/services/repair_queue_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RepairQueueService {
  static const _key = 'repairQueue';

  static Future<List<Map<String, dynamic>>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List list = jsonDecode(raw);
    return List<Map<String, dynamic>>.from(list);
  }

  static Future<List<Map<String, dynamic>>> getNeedFollowUp() async {
    final all = await getAll();
    return all
        .where((e) =>
            (e['statusTeknisi'] ?? '').toString().toLowerCase() == 'followup')
        .toList();
  }

  /// DRIVER kirim / update laporan
  static Future<void> upsertFromDriver({
    required String plate,
    required String brand,
    required String issue,
    required String driverUsername,
    String? note,
    String? driverExtraNeeds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await getAll();

    final normPlate = plate.trim().toUpperCase();
    final index = all.indexWhere(
      (e) => (e['plate'] ?? '').toString().toUpperCase() == normPlate,
    );

    // data dasar dari driver
    final dataBaru = {
      'plate': normPlate,
      'brand': brand,
      'issue': issue,
      'driverUsername': driverUsername,
      'note': note ?? '',
      'driverExtraNeeds': driverExtraNeeds ?? '',
      'lastUpdate': DateTime.now().toIso8601String(),
    };

    if (index >= 0) {
      // 🚨 di sini kita PAKSA balik ke menunggu
      dataBaru['statusTeknisi'] = 'menunggu';
      dataBaru['techNote'] = '';
      all[index] = dataBaru;
    } else {
      // laporan baru
      dataBaru['statusTeknisi'] = 'menunggu';
      dataBaru['techNote'] = '';
      all.add(dataBaru);
    }

    await prefs.setString(_key, jsonEncode(all));
  }

  static Future<void> updateFromTeknisi({
    required String plate,
    String? techNote,
    String status = 'followup',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await getAll();
    final index = all.indexWhere(
      (e) =>
          (e['plate'] ?? '').toString().toUpperCase() ==
          plate.trim().toUpperCase(),
    );

    if (index < 0) return;

    final current = all[index];
    current['techNote'] = techNote ?? current['techNote'] ?? '';
    current['statusTeknisi'] = status;
    current['lastUpdate'] = DateTime.now().toIso8601String();

    all[index] = current;
    await prefs.setString(_key, jsonEncode(all));
  }

  static Future<List<Map<String, dynamic>>> getTicketsForTechnician() async {
    final all = await getAll();
    return all.where((e) {
      final s = (e['statusTeknisi'] ?? '').toString().toLowerCase();
      return s == 'menunggu' || s == 'followup';
    }).toList();
  }

  static Future<void> updateTicket({
    required String plate,
    String? techNote,
    String status = 'followup',
  }) async {
    await updateFromTeknisi(
      plate: plate,
      techNote: techNote,
      status: status,
    );
  }
}

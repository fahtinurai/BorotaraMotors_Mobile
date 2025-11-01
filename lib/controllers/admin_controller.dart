// lib/controllers/admin_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/repair_queue_service.dart';
import '../services/local_storage_service.dart';

class AdminController with ChangeNotifier {
  // key penyimpanan data di SharedPreferences
  static const _userKeysKey = 'userKeys';
  static const _vehiclesKey = 'vehiclesData';
  static const _driverVehiclesKey = 'driverVehicles';

  // state untuk panel admin
  List<Map<String, dynamic>> userKeys = [];
  List<Map<String, dynamic>> vehicles = [];
  List<Map<String, dynamic>> driverVehicles = [];
  int followUpCount = 0;

  AdminController() {
    loadAll();
  }

  /// ambil semua data dari storage lokal
  Future<void> loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    // 1) user keys
    final rawUsers = prefs.getString(_userKeysKey);
    if (rawUsers != null) {
      userKeys = List<Map<String, dynamic>>.from(jsonDecode(rawUsers));
    }

    // 2) vehicles
    final rawVehicles = prefs.getString(_vehiclesKey);
    if (rawVehicles != null) {
      vehicles = List<Map<String, dynamic>>.from(jsonDecode(rawVehicles));
    }

    // 3) driverVehicles
    final rawDV = prefs.getString(_driverVehiclesKey);
    if (rawDV != null) {
      driverVehicles = List<Map<String, dynamic>>.from(jsonDecode(rawDV));
    }

    // 4) hitung follow up dari antrian perbaikan
    try {
      final need = await RepairQueueService.getNeedFollowUp();
      followUpCount = need.length;
    } catch (_) {
      followUpCount = 0;
    }

    // 5) sinkronkan userKeys ke LocalStorageService (supaya login dropdown bisa pakai)
    await _syncUserKeysToLocalStorage();

    notifyListeners();
  }

  // ======================
  // 🔑 USER KEY (admin bikin akun)
  // ======================
  Future<void> addUserKey({
    required String username,
    required String role,
    required String key,
  }) async {
    userKeys.add({
      'username': username,
      'role': role.toLowerCase(),
      'key': key,
    });
    await _saveUserKeys();
    notifyListeners();
  }

  Future<void> deleteUserKey(String username) async {
    userKeys.removeWhere(
      (u) => (u['username'] as String).toLowerCase() == username.toLowerCase(),
    );
    await _saveUserKeys();
    notifyListeners();
  }

  Future<void> _saveUserKeys() async {
    // simpan ke SharedPreferences (biar panel admin kebaca)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKeysKey, jsonEncode(userKeys));

    // simpan juga ke LocalStorageService (biar login bisa pakai)
    await _syncUserKeysToLocalStorage();
  }

  Future<void> _syncUserKeysToLocalStorage() async {
    final svc = LocalStorageService();
    await svc.init();

    // masukkan satu-satu ke storage login
    for (final u in userKeys) {
      await svc.addOrUpdateUser({
        'username': u['username'],
        'role': u['role'],
        'key': u['key'],
      });
    }
  }

  // ======================
  // 🚗 KENDARAAN
  // ======================
  Future<String?> addVehicle({
    required String brand,
    required String plate,
  }) async {
    final normPlate = plate.trim().toUpperCase();

    // cek duplikat
    final exists = vehicles.any(
      (v) => (v['plate'] as String).toUpperCase() == normPlate,
    );
    if (exists) {
      return 'Plat sudah terdaftar.';
    }

    vehicles.add({
      'brand': brand.trim(),
      'plate': normPlate,
    });
    await _saveVehicles();
    notifyListeners();
    return null;
  }

  Future<void> deleteVehicle(String plate) async {
    final normPlate = plate.trim().toUpperCase();
    vehicles.removeWhere(
      (v) => (v['plate'] as String).toUpperCase() == normPlate,
    );
    await _saveVehicles();
    notifyListeners();
  }

  Future<void> _saveVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vehiclesKey, jsonEncode(vehicles));
  }

  // ======================
  // 👨‍🔧 ASSIGN KENDARAAN KE DRIVER
  // ======================
  Future<String?> assignVehicle({
    required String driverUsername,
    required String plate,
  }) async {
    final normDriver = driverUsername.trim();
    final normPlate = plate.trim().toUpperCase();

    // 1) cek plat ada di daftar kendaraan
    final vehicle = vehicles.firstWhere(
      (v) => (v['plate'] as String).toUpperCase() == normPlate,
      orElse: () => <String, dynamic>{},
    );
    if (vehicle.isEmpty) {
      return 'Plat belum terdaftar di daftar kendaraan.';
    }

    // 2) cek apakah plat sudah dipegang driver lain
    final usedByOtherDriver = driverVehicles.any((dv) {
      final dname = (dv['username'] ?? '').toString();
      if (dname.toLowerCase() == normDriver.toLowerCase()) {
        return false; // ini driver yang sama → dicek di bawah
      }
      final List listVeh = dv['vehicles'] ?? [];
      return listVeh.any(
        (vh) => (vh['plate'] as String).toUpperCase() == normPlate,
      );
    });
    if (usedByOtherDriver) {
      return 'Plat ini sudah di-assign ke driver lain.';
    }

    // 3) cari entri driver ini
    Map<String, dynamic> entry = driverVehicles.firstWhere(
      (dv) =>
          (dv['username'] as String).toLowerCase() == normDriver.toLowerCase(),
      orElse: () => <String, dynamic>{},
    );

    if (entry.isEmpty) {
      // driver belum punya entri → buat baru
      entry = {
        'username': normDriver,
        'vehicles': <Map<String, dynamic>>[
          {
            'brand': vehicle['brand'],
            'plate': normPlate,
          }
        ],
      };
      driverVehicles.add(entry);
    } else {
      // driver sudah punya entri → cek apakah sudah punya plat ini
      final List listVeh = entry['vehicles'] ?? <Map<String, dynamic>>[];
      final alreadyHas = listVeh.any(
        (vh) => (vh['plate'] as String).toUpperCase() == normPlate,
      );
      if (alreadyHas) {
        return 'Driver ini sudah punya kendaraan dengan plat tersebut.';
      }
      listVeh.add({
        'brand': vehicle['brand'],
        'plate': normPlate,
      });
      entry['vehicles'] = listVeh;
    }

    await _saveDriverVehicles();
    notifyListeners();
    return null;
  }

  Future<void> deleteAssign({
    required String driverUsername,
    required String plate,
  }) async {
    final normDriver = driverUsername.trim().toLowerCase();
    final normPlate = plate.trim().toUpperCase();

    for (final dv in driverVehicles) {
      if ((dv['username'] as String).toLowerCase() == normDriver) {
        final List listVeh = dv['vehicles'] ?? [];
        listVeh.removeWhere(
          (vh) => (vh['plate'] as String).toUpperCase() == normPlate,
        );
        dv['vehicles'] = listVeh;
      }
    }

    await _saveDriverVehicles();
    notifyListeners();
  }

  Future<void> _saveDriverVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_driverVehiclesKey, jsonEncode(driverVehicles));
  }

  // ======================
  // 🔁 FOLLOW UP
  // ======================
  Future<void> refreshFollowUp() async {
    try {
      final need = await RepairQueueService.getNeedFollowUp();
      followUpCount = need.length;
    } catch (_) {
      followUpCount = 0;
    }
    notifyListeners();
  }
}

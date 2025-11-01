// lib/services/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _usersKey = 'users_borotara';
  static const _activeUserKey = 'active_user';
  static const _activeRoleKey = 'active_role';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// bikin user awal kalau masih kosong
  Future<void> ensureSeedUsers() async {
    final raw = _prefs.getString(_usersKey);
    if (raw != null && raw.isNotEmpty) return;

    final users = [
      {
        'role': 'admin',
        'username': 'admin',
        'key': 'ADM-001',
      },
      {
        'role': 'driver',
        'username': 'driver1',
        'key': 'DRV-001',
      },
      {
        'role': 'teknisi',
        'username': 'teknisi1',
        'key': 'TEK-001',
      },
    ];

    await _prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<List<Map<String, dynamic>>> _getUsers() async {
    final raw = _prefs.getString(_usersKey);
    if (raw == null) return [];
    final List list = jsonDecode(raw);
    return List<Map<String, dynamic>>.from(list);
  }

  /// login umum: cek role + username + key
  Future<bool> loginWithRoleAndKey({
    required String role,
    required String username,
    required String key,
  }) async {
    final users = await _getUsers();
    final found = users.firstWhere(
      (u) =>
          (u['role'] == role) &&
          (u['username'] == username) &&
          (u['key'] == key),
      orElse: () => {},
    );

    if (found.isEmpty) return false;

    // simpan session
    await _prefs.setString(_activeUserKey, username);
    await _prefs.setString(_activeRoleKey, role);

    return true;
  }

  /// dipakai panel admin buat nambah / update user
  Future<void> addOrUpdateUser(Map<String, dynamic> user) async {
    final users = await _getUsers();
    final idx = users.indexWhere(
      (u) => u['username'] == user['username'] && u['role'] == user['role'],
    );
    if (idx >= 0) {
      users[idx] = user;
    } else {
      users.add(user);
    }
    await _prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return _getUsers();
  }

  // ✅ ambil user yang lagi login
  Future<String?> getActiveUser() async {
    return _prefs.getString(_activeUserKey);
  }

  Future<String?> getActiveRole() async {
    return _prefs.getString(_activeRoleKey);
  }

  // ✅ LOGOUT: cuma hapus session, BUKAN hapus semua user
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeUserKey);
    await prefs.remove(_activeRoleKey);
    // JANGAN prefs.clear(); karena itu ngehapus semua, termasuk user yang admin tambah
  }
}

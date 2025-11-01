// lib/services/auth_service.dart
import 'local_storage_service.dart';

class AuthService {
  /// login versi baru: harus ada role, username, dan key
  static Future<Map<String, dynamic>?> login({
    required String role,
    required String username,
    required String key,
  }) async {
    final store = LocalStorageService();
    await store.init();
    await store.ensureSeedUsers();

    final ok = await store.loginWithRoleAndKey(
      role: role,
      username: username,
      key: key,
    );

    if (!ok) return null;

    // ambil semua user biar bisa balikin data user yg cocok
    final all = await store.getAllUsers();
    final found = all.firstWhere(
      (u) =>
          u['role'] == role &&
          u['username'] == username &&
          u['key'] == key,
      orElse: () => {},
    );

    // di sini kamu bisa simpan "session" juga kalau mau,
    // tapi karena LocalStorageService kita belum punya method simpan session,
    // kita cukup balikin data user-nya aja.
    return found.isEmpty ? null : found;
  }

  /// kalau nanti kamu tambahin simpan session di LocalStorageService,
  /// tinggal aktifin logout ini
  static Future<void> logout() async {
    // final store = LocalStorageService();
    // await store.init();
    // await store.clearSession(); // bikin method ini kalau perlu
  }
}

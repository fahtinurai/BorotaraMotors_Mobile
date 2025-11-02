// lib/ui/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:borotara_project/services/local_storage_service.dart';

import '../admin/admin_dashboard_page.dart';
import '../driver/driver_dashboard_page.dart';
import '../teknisi/teknisi_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _keyCtrl = TextEditingController();

  String _selectedRole = 'admin';
  String? _error;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final svc = LocalStorageService();
    await svc.init();
    await svc.ensureSeedUsers();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _keyCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final svc = LocalStorageService();
    await svc.init();

    final ok = await svc.loginWithRoleAndKey(
      role: _selectedRole,
      username: _usernameCtrl.text.trim(),
      key: _keyCtrl.text.trim(),
    );

    if (!ok) {
      setState(() {
        _error = 'User / key tidak cocok atau belum dibuat admin';
      });
      return;
    }

    if (!mounted) return;

    // =========================
    // ARAHKAN SESUAI ROLE
    // =========================
    if (_selectedRole == 'admin') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
      );
    } else if (_selectedRole == 'driver') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DriverDashboardPage(
            username: _usernameCtrl.text.trim(),
            // 👇 ini yang tadi hilang
            userKey: _keyCtrl.text.trim(),
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const TeknisiDashboardPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // dropdown role
                Row(
                  children: [
                    const Text('Masuk sebagai:'),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _selectedRole,
                      items: const [
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        DropdownMenuItem(
                            value: 'driver', child: Text('Driver')),
                        DropdownMenuItem(
                            value: 'teknisi', child: Text('Teknisi')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _selectedRole = v;
                          _error = null;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // username
                TextFormField(
                  controller: _usernameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Isi username dulu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // key
                TextFormField(
                  controller: _keyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Key',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Isi key dulu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                if (_error != null)
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onLogin,
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // warna utama aplikasi
  static const Color primary = Colors.indigo;

  // ===== yang tadinya sudah kita pakai =====
  static const Color bgPage = Color(0xFFF8F9FB);
  static const Color bgCard = Colors.white;
  static const Color textMain = Colors.black87;
  static const Color textDim = Colors.black54;
  static const Color success = Colors.green;
  static const Color danger = Colors.redAccent;

  // ===== alias biar file lain yang lama gak error =====
  // beberapa file pakai AppColors.background -> samain ke bgPage
  static const Color background = bgPage;

  // beberapa file pakai AppColors.secondary -> kasih warna turunan
  static const Color secondary = Colors.indigoAccent;
}

// lib/ui/admin/admin_dashboard_page.dart
import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../controllers/admin_controller.dart';
import '../shared/responsive_scaffold.dart';

import 'admin_navbar.dart';
import 'admin_home_panel.dart';
import 'admin_key_panel.dart';
import 'admin_vehicle_panel.dart';
import 'admin_assign_panel.dart';
import 'admin_followup_panel.dart';
import 'admin_profile_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int selectedPanel = 0;
  final controller = AdminController();

  void _openFollowUp() {
    setState(() {
      selectedPanel = 4; // <- panel follow up kamu di switch ada di case 4
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveMobileScaffold(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              AdminNavBar(
                onSelect: (i) => setState(() => selectedPanel = i),
                selectedIndex: selectedPanel,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildPanel(selectedPanel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanel(int i) {
    switch (i) {
      case 0:
        // ↓↓↓ kirim callback ke home
        return AdminHomePanel(
          controller: controller,
          onOpenFollowUp: _openFollowUp,
        );
      case 1:
        return AdminKeyPanel(controller: controller);
      case 2:
        return AdminVehiclePanel(controller: controller);
      case 3:
        return AdminAssignPanel(controller: controller);
      case 4:
        return AdminFollowUpPanel(controller: controller);
      case 5:
        return const AdminProfilePage(username: 'Admin');
      default:
        return const SizedBox.shrink();
    }
  }
}

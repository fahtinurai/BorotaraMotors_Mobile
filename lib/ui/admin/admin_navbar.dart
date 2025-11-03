// lib/ui/admin/admin_navbar.dart
import 'package:flutter/material.dart';

class AdminNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const AdminNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            Expanded(child: _item(0, Icons.dashboard, 'Home')),
            Expanded(child: _item(1, Icons.vpn_key, 'Key')),
            Expanded(child: _item(2, Icons.directions_car, 'Kendaraan')),
            Expanded(child: _item(3, Icons.assignment_ind, 'Assign')),
            Expanded(child: _item(4, Icons.report, 'Follow-up')),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => onSelect(99),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(int index, IconData icon, String label) {
    final active = index == selectedIndex;
    return InkWell(
      onTap: () => onSelect(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: active ? Colors.blue : Colors.grey),
            Text(
              label,
              overflow: TextOverflow.ellipsis, 
              style: TextStyle(
                fontSize: 12, 
                color: active ? Colors.blue : Colors.grey,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
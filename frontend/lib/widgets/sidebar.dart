import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/customers_screen.dart';
import '../screens/staff_screen.dart';
import '../screens/service_screen.dart';
import '../screens/appointment_screen.dart';

class Sidebar extends StatelessWidget {
  final Function(Widget) onSelectScreen;

  const Sidebar({
    super.key,
    required this.onSelectScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            child: Text(
              "SPA CRM PRO",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),

          _item(
            icon: Icons.dashboard,
            label: "Dashboard",
            onTap: () => onSelectScreen(const DashboardScreen()),
          ),

          _item(
            icon: Icons.people,
            label: "Khách hàng",
            onTap: () => onSelectScreen(const CustomersScreen()),
          ),

          _item(
            icon: Icons.badge,
            label: "Nhân viên",
            onTap: () => onSelectScreen(const StaffScreen()),
          ),

          _item(
            icon: Icons.design_services,
            label: "Dịch vụ",
            onTap: () => onSelectScreen(const ServiceScreen()),
          ),

          _item(
            icon: Icons.event_available,
            label: "Lịch hẹn",
            onTap: () => onSelectScreen(
              const AppointmentScreen(spaId: "spa-demo-123"),
            ),
          ),

          const Spacer(),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

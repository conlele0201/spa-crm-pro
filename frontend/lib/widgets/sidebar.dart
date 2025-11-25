import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onNavigate;

  const Sidebar({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFF1E293B),
      child: ListView(
        children: [
          const SizedBox(height: 20),

          _menuItem(
            icon: Icons.dashboard,
            label: "Dashboard",
            page: "dashboard",
          ),

          _menuItem(
            icon: Icons.people,
            label: "Khách hàng",
            page: "customers",
          ),

          _menuItem(
            icon: Icons.groups,
            label: "Nhân viên",
            page: "staff",
          ),

          _menuItem(
            icon: Icons.design_services,
            label: "Dịch vụ",
            page: "services",
          ),

          _menuItem(
            icon: Icons.event,
            label: "Lịch hẹn",
            page: "appointments",
          ),

          _menuItem(
            icon: Icons.receipt_long,
            label: "Hóa đơn",
            page: "billing",
          ),

          _menuItem(
            icon: Icons.inventory_2,
            label: "Kho mỹ phẩm",
            page: "inventory",
          ),

          _menuItem(
            icon: Icons.schedule,
            label: "Ca làm việc",
            page: "staff_shifts",
          ),

          _menuItem(
            icon: Icons.spa,
            label: "Liệu trình",
            page: "treatment_sessions",
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required String page,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      onTap: () => onNavigate(page),
    );
  }
}

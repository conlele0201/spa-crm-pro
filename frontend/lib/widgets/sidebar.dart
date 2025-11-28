import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onNavigate;
  final String selected;

  const Sidebar({
    super.key,
    required this.onNavigate,
    required this.selected,
  });

  Widget _menuItem({
    required String id,
    required IconData icon,
    required String label,
  }) {
    final bool active = selected == id;

    return InkWell(
      onTap: () => onNavigate(id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: active ? Colors.blue.shade100 : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: active ? Colors.blue : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: active ? Colors.blue : Colors.grey[700],
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? Colors.blue : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "SPA CRM PRO",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          _menuItem(
            id: "dashboard",
            icon: Icons.dashboard,
            label: "Dashboard",
          ),
          _menuItem(
            id: "customers",
            icon: Icons.people,
            label: "Customers",
          ),
          _menuItem(
            id: "staff",
            icon: Icons.badge,
            label: "Staff",
          ),
          _menuItem(
            id: "services",
            icon: Icons.design_services,
            label: "Services",
          ),
          _menuItem(
            id: "appointments",
            icon: Icons.calendar_today,
            label: "Appointments",
          ),
          _menuItem(
            id: "billing",
            icon: Icons.receipt_long,
            label: "Billing",
          ),
          _menuItem(
            id: "inventory",
            icon: Icons.inventory,
            label: "Inventory",
          ),
          _menuItem(
            id: "staff_shifts",
            icon: Icons.access_time,
            label: "Staff Shifts",
          ),
          _menuItem(
            id: "treatment_sessions",
            icon: Icons.healing,
            label: "Treatment Sessions",
          ),
          _menuItem(
            id: "memberships",
            icon: Icons.card_membership,
            label: "Memberships",
          ),
          _menuItem(
            id: "promotions",
            icon: Icons.local_offer,
            label: "Promotions",
          ),
          _menuItem(
            id: "notifications",
            icon: Icons.notifications,
            label: "Notifications",
          ),
          _menuItem(
            id: "subscriptions",
            icon: Icons.subscriptions,
            label: "Subscriptions",
          ),

          const Spacer(),

          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "© 2025 Spa CRM Pro",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

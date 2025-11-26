import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(String) onSelect;
  final String selected;

  const Sidebar({
    super.key,
    required this.onSelect,
    required this.selected,
  });

  Widget menuItem({
    required String id,
    required IconData icon,
    required String label,
  }) {
    return Builder(
      builder: (context) {
        final bool isActive = selected == id;
        return InkWell(
          onTap: () => onSelect(id),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: isActive ? Colors.blue.shade100 : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: isActive ? Colors.blue : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: isActive ? Colors.blue : Colors.grey[700]),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.blue : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

          // Dashboard
          menuItem(
            id: "dashboard",
            icon: Icons.dashboard,
            label: "Dashboard",
          ),

          // Customers
          menuItem(
            id: "customers",
            icon: Icons.people,
            label: "Customers",
          ),

          // Staff
          menuItem(
            id: "staff",
            icon: Icons.person_pin,
            label: "Staff",
          ),

          // Services
          menuItem(
            id: "services",
            icon: Icons.design_services,
            label: "Services",
          ),

          // Appointments
          menuItem(
            id: "appointments",
            icon: Icons.calendar_today,
            label: "Appointments",
          ),

          // Billing
          menuItem(
            id: "billing",
            icon: Icons.receipt_long,
            label: "Billing",
          ),

          // Inventory
          menuItem(
            id: "inventory",
            icon: Icons.inventory,
            label: "Inventory",
          ),

          // Staff Shifts
          menuItem(
            id: "staff_shifts",
            icon: Icons.access_time_filled,
            label: "Staff Shifts",
          ),

          // Memberships
          menuItem(
            id: "memberships",
            icon: Icons.card_membership,
            label: "Memberships",
          ),

          // Treatment Sessions
          menuItem(
            id: "treatment_sessions",
            icon: Icons.healing,
            label: "Treatment Sessions",
          ),

          // ⭐ Promotions (mục mới)
          menuItem(
            id: "promotions",
            icon: Icons.local_offer,
            label: "Promotions",
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

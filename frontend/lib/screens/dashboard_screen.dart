import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class DashboardScreen extends StatefulWidget {
  final String userRole;
  final String? spaId;

  const DashboardScreen({
    super.key,
    required this.userRole,
    required this.spaId,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedMenu = "dashboard";

  void _navigate(String menu) {
    setState(() {
      selectedMenu = menu;
    });
  }

  Widget _screen() {
    switch (selectedMenu) {
      case "customers":
        return const Center(child: Text("Customers Screen"));
      case "staff":
        return const Center(child: Text("Staff Screen"));
      case "services":
        return const Center(child: Text("Services Screen"));
      case "appointments":
        return const Center(child: Text("Appointments Screen"));
      case "billing":
        return const Center(child: Text("Billing Screen"));
      case "inventory":
        return const Center(child: Text("Inventory Screen"));
      case "staff_shifts":
        return const Center(child: Text("Staff Shifts Screen"));
      case "treatment_sessions":
        return const Center(child: Text("Treatment Sessions Screen"));
      case "memberships":
        return const Center(child: Text("Memberships Screen"));
      case "promotions":
        return const Center(child: Text("Promotions Screen"));
      case "notifications":
        return const Center(child: Text("Notifications Screen"));
      case "subscriptions":
        return const Center(child: Text("Subscriptions Screen"));

      case "license":
        return const Center(child: Text("License Management Screen"));

      default:
        return const Center(child: Text("Dashboard"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selected: selectedMenu,
            userRole: widget.userRole,
            onNavigate: _navigate,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Logged in as: ${widget.userRole.toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: _screen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

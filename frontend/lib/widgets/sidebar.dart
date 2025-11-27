import 'package:flutter/material.dart';
import '../screens/dashboard.dart';
import '../screens/customers_screen.dart';
import '../screens/staff_screen.dart';
import '../screens/services_screen.dart';
import '../screens/appointments_screen.dart';
import '../screens/billing_screen.dart';
import '../screens/inventory_screen.dart';
import '../screens/staff_shifts_screen.dart';
import '../screens/treatment_sessions_screen.dart';
import '../screens/memberships_screen.dart';
import '../screens/promotions_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/subscription_screen.dart';

class Sidebar extends StatelessWidget {
  final Function(Widget) onSelectPage;

  const Sidebar({super.key, required this.onSelectPage});

  Widget buildMenuTile(String title, IconData icon, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () => onSelectPage(page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xff2C3E50),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xff1A252F)),
              child: Center(
                child: Text(
                  "SPA CRM PRO",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

            buildMenuTile("Dashboard", Icons.dashboard, const DashboardScreen()),
            buildMenuTile("Customers", Icons.people, const CustomersScreen()),
            buildMenuTile("Staff", Icons.person, const StaffScreen()),
            buildMenuTile("Services", Icons.spa, const ServicesScreen()),
            buildMenuTile("Appointments", Icons.calendar_today, const AppointmentsScreen()),
            buildMenuTile("Billing", Icons.receipt_long, const BillingScreen()),
            buildMenuTile("Inventory", Icons.inventory, const InventoryScreen()),
            buildMenuTile("Staff Shifts", Icons.schedule, const StaffShiftsScreen()),
            buildMenuTile("Treatment Sessions", Icons.healing, const TreatmentSessionsScreen()),
            buildMenuTile("Memberships", Icons.card_membership, const MembershipsScreen()),
            buildMenuTile("Promotions", Icons.local_offer, const PromotionsScreen()),
            buildMenuTile("Notifications", Icons.notifications, const NotificationsScreen()),

            // ⭐⭐ NEW ITEM: SUBSCRIPTIONS ⭐⭐
            buildMenuTile("Subscriptions", Icons.subscriptions, const SubscriptionScreen()),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';
import 'customers_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  final DashboardController dashboard = DashboardController();
  final String spaId = "spa-demo-123";

  final List<String> menu = [
    "Dashboard",
    "Khách hàng",
  ];

  @override
  void initState() {
    super.initState();
    dashboard.loadDashboard(spaId);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _dashboardUI(),
      const CustomersScreen(),
    ];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) {
              setState(() => selectedIndex = i);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text("Dashboard"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_alt_outlined),
                selectedIcon: Icon(Icons.people),
                label: Text("Khách hàng"),
              ),
            ],
          ),

          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }

  // UI Dashboard chính
  Widget _dashboardUI() {
    return AnimatedBuilder(
      animation: dashboard,
      builder: (_, __) {
        if (dashboard.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  _box("Khách mới hôm nay", dashboard.todayCustomers),
                  const SizedBox(width: 20),
                  _box("Lịch hẹn hôm nay", dashboard.todayAppointments),
                  const SizedBox(width: 20),
                  _box("Doanh thu hôm nay", dashboard.todayRevenue),
                ],
              ),
              const SizedBox(height: 30),
              _todayScheduleList(),
            ],
          ),
        );
      },
    );
  }

  Widget _box(String title, int value) {
    return Expanded(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              value.toString(),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _todayScheduleList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Lịch hẹn hôm nay",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...dashboard.todaySchedule.map((a) {
          return Card(
            child: ListTile(
              title: Text(a['customer_name'] ?? "Chưa rõ"),
              subtitle: Text("Giờ: ${a['scheduled_at']}"),
            ),
          );
        })
      ],
    );
  }
}

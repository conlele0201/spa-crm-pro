import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar trái
          Container(
            width: 220,
            color: const Color(0xFF1F2937),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Spa CRM Pro",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _menuItem(Icons.people, "Khách hàng"),
                _menuItem(Icons.calendar_month, "Lịch hẹn"),
                _menuItem(Icons.medical_services, "Dịch vụ"),
                _menuItem(Icons.local_offer, "Gói liệu trình"),
                _menuItem(Icons.inventory, "Kho hàng"),
                _menuItem(Icons.person, "Nhân viên"),
                _menuItem(Icons.receipt_long, "Hóa đơn"),
                _menuItem(Icons.settings, "Cài đặt"),

                const Spacer(),

                // Logout
                InkWell(
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Đăng xuất",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // Khu vực nội dung chính
          Expanded(
            child: Column(
              children: [
                // TOPBAR
                Container(
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // BODY
                Expanded(
                  child: Container(
                    color: const Color(0xFFF3F4F6),
                    child: const Center(
                      child: Text(
                        "Welcome to Spa CRM Pro",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../controllers/menu_controller.dart';
import '../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _auth = AuthService();
  final MenuController menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // SIDEBAR
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

                // MENU LIST
                Expanded(
                  child: ListView(
                    children: menuController.items.map((item) {
                      bool active = item.key == menuController.activeKey;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            menuController.setActive(item.key);
                          });
                        },
                        child: Container(
                          color: active ? Colors.blueGrey.shade700 : Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          child: Row(
                            children: [
                              Icon(item.icon, color: Colors.white70),
                              const SizedBox(width: 12),
                              Text(
                                item.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // LOGOUT
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

          // MAIN BODY
          Expanded(
            child: Column(
              children: [
                // TOPBAR
                Container(
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    menuController.items
                        .firstWhere((e) => e.key == menuController.activeKey)
                        .title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    color: const Color(0xFFF3F4F6),
                    child: const Center(
                      child: Text(
                        "Màn hình tính năng sẽ hiển thị tại đây",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

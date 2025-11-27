import 'package:flutter/material.dart';
import '../controllers/notification_controller.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = NotificationController();

  @override
  void initState() {
    super.initState();
    controller.load("spa_1"); // tạm thời hardcode, sau sẽ thay bằng spaId thật
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: controller.notifications.isEmpty
                ? const Center(child: Text("No notifications"))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Title")),
                        DataColumn(label: Text("Message")),
                        DataColumn(label: Text("Type")),
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: controller.notifications.map((NotificationModel n) {
                        return DataRow(cells: [
                          DataCell(Text(n.title)),
                          DataCell(Text(n.message)),
                          DataCell(Text(n.type)),
                          DataCell(Text(n.createdAt.toString().split(" ")[0])),
                          DataCell(
                            Text(
                              n.isRead ? "Read" : "Unread",
                              style: TextStyle(
                                color: n.isRead ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                if (!n.isRead)
                                  IconButton(
                                    icon: const Icon(Icons.done, color: Colors.blue),
                                    onPressed: () {
                                      controller.markRead(n.id, n.spaId);
                                    },
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    controller.delete(n.id, n.spaId);
                                  },
                                )
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
        );
      },
    );
  }
}


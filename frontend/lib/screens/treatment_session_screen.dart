import 'package:flutter/material.dart';
import '../controllers/treatment_session_controller.dart';
import '../models/treatment_session_model.dart';
import 'treatment_session_form.dart';

class TreatmentSessionScreen extends StatefulWidget {
  final String spaId;

  const TreatmentSessionScreen({
    super.key,
    required this.spaId,
  });

  @override
  State<TreatmentSessionScreen> createState() => _TreatmentSessionScreenState();
}

class _TreatmentSessionScreenState extends State<TreatmentSessionScreen> {
  final TreatmentSessionController controller = TreatmentSessionController();

  @override
  void initState() {
    super.initState();
    controller.loadSessions(widget.spaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Theo dõi liệu trình")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => TreatmentSessionForm(
              spaId: widget.spaId,
              controller: controller,
            ),
          );
        },
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          if (controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.sessionList.isEmpty) {
            return const Center(child: Text("Chưa có buổi liệu trình nào"));
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: controller.sessionList.map((session) {
              return Card(
                child: ListTile(
                  title: Text("Khách hàng: ${session.customerId}"),
                  subtitle: Text(
                    "Liệu trình: ${session.treatmentId}\n"
                    "Buổi số: ${session.sessionNumber}\n"
                    "Trạng thái: ${session.status}\n"
                    "Ghi chú: ${session.note ?? '--'}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteSession(session.id, widget.spaId);
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => TreatmentSessionForm(
                        spaId: widget.spaId,
                        controller: controller,
                        session: session,
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}


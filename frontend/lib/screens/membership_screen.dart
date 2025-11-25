import 'package:flutter/material.dart';
import '../controllers/membership_controller.dart';
import '../models/membership_model.dart';
import 'membership_form.dart';

class MembershipScreen extends StatefulWidget {
  final String spaId;

  const MembershipScreen({
    super.key,
    required this.spaId,
  });

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final MembershipController controller = MembershipController();

  @override
  void initState() {
    super.initState();
    controller.loadMemberships(widget.spaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gói hội viên")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => MembershipForm(
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

          if (controller.membershipList.isEmpty) {
            return const Center(child: Text("Chưa có gói hội viên nào"));
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: controller.membershipList.map((m) {
              return Card(
                child: ListTile(
                  title: Text(m.membershipName),
                  subtitle: Text(
                    "Khách hàng: ${m.customerId}\n"
                    "Giá gói: ${m.price}\n"
                    "Còn lại: ${m.remainingBalance}\n"
                    "Chiết khấu: ${m.discountRate}%",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => controller.deleteMembership(m.id, widget.spaId),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => MembershipForm(
                        spaId: widget.spaId,
                        controller: controller,
                        membership: m,
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


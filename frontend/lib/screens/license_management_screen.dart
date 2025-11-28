import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/license_service.dart';

class LicenseManagementScreen extends StatefulWidget {
  const LicenseManagementScreen({super.key});

  @override
  State<LicenseManagementScreen> createState() =>
      _LicenseManagementScreenState();
}

class _LicenseManagementScreenState extends State<LicenseManagementScreen> {
  final supabase = Supabase.instance.client;
  final licenseService = LicenseService();

  List<Map<String, dynamic>> spas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSpas();
  }

  Future<void> loadSpas() async {
    loading = true;
    setState(() {});

    spas = await supabase.from("spas").select();

    loading = false;
    setState(() {});
  }

  Future<Map<String, dynamic>?> getLicense(String spaId) async {
    return await licenseService.getLicense(spaId);
  }

  Future<void> renew(String spaId) async {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Renew License"),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(labelText: "Months to extend (e.g. 12)"),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final months = int.tryParse(controller.text) ?? 0;
                if (months > 0) {
                  await licenseService.renewLicense(spaId: spaId, months: months);
                  Navigator.pop(context);
                  loadSpas();
                }
              },
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }

  Future<void> toggleActive(String spaId, bool current) async {
    if (current) {
      await licenseService.deactivateLicense(spaId);
    } else {
      await licenseService.activateLicense(spaId);
    }
    loadSpas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("License Management")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: supabase.from("spas").select(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final spaList = snapshot.data as List<dynamic>;

                return ListView.builder(
                  itemCount: spaList.length,
                  itemBuilder: (_, i) {
                    final spa = spaList[i];
                    final spaId = spa['id'];

                    return FutureBuilder(
                      future: getLicense(spaId),
                      builder: (_, snap) {
                        final license = snap.data;

                        String status = "NO LICENSE";
                        String start = "-";
                        String end = "-";
                        bool active = false;

                        if (license != null) {
                          start = license["start_date"] ?? "-";
                          end = license["end_date"] ?? "-";
                          active = license["active"] ?? false;

                          final today = DateTime.now();
                          if (end != "-") {
                            final endDt = DateTime.parse(end);
                            if (today.isAfter(endDt)) {
                              status = "EXPIRED";
                            } else {
                              status = active ? "ACTIVE" : "INACTIVE";
                            }
                          }
                        }

                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(spa['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Status: $status"),
                                Text("Start: $start"),
                                Text("End: $end"),
                                Text("Active: $active"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // renew button
                                IconButton(
                                  icon: const Icon(Icons.update),
                                  onPressed: () => renew(spaId),
                                ),

                                // toggle active
                                IconButton(
                                  icon: Icon(
                                    active ? Icons.lock_open : Icons.lock,
                                  ),
                                  onPressed: () => toggleActive(spaId, active),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}


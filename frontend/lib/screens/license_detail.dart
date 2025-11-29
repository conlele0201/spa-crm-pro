import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'license_renew.dart';

class LicenseDetailScreen extends StatefulWidget {
  final String licenseId;

  const LicenseDetailScreen({super.key, required this.licenseId});

  @override
  State<LicenseDetailScreen> createState() => _LicenseDetailScreenState();
}

class _LicenseDetailScreenState extends State<LicenseDetailScreen> {
  Map<String, dynamic>? license;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    final data = await Supabase.instance.client
        .from("licenses")
        .select("*, spas(name)")
        .eq("id", widget.licenseId)
        .maybeSingle();

    setState(() {
      license = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (license == null) {
      return const Center(child: Text("License not found."));
    }

    final spaName = license!['spas']?['name'] ?? "Unknown Spa";
    final start = license!['start_date'] ?? "";
    final end = license!['end_date'] ?? "";
    final active = license!['active'] ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text("License Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Spa: $spaName",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Text("Start Date: $start", style: const TextStyle(fontSize: 16)),
            Text("End Date: $end", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            Text(
              "Status: ${active ? "ACTIVE" : "INACTIVE"}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: active ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () async {
                final renewed = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LicenseRenewScreen(licenseId: widget.licenseId),
                  ),
                );

                if (renewed == true) {
                  loadDetail();
                }
              },
              child: const Text("Renew License"),
            ),
          ],
        ),
      ),
    );
  }
}

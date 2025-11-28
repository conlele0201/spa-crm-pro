import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final status = license!['status'] ?? "unknown";
    final created = license!['created_at'] ?? "";
    final expire = license!['expires_at'] ?? "";

    final expiresAt = DateTime.tryParse(expire.toString());
    final now = DateTime.now();
    final daysLeft = expiresAt != null
        ? expiresAt.difference(now).inDays
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text("License Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Spa: $spaName",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Text("Status: ${status.toUpperCase()}",
                style: const TextStyle(fontSize: 16)),
            Text("Created at: $created", style: const TextStyle(fontSize: 16)),
            Text("Expires at: $expire", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            if (daysLeft != null)
              Text("Days remaining: $daysLeft",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: daysLeft <= 0 ? Colors.red : Colors.green)),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                // bước 71.3 sẽ xử lý Renew
              },
              child: const Text("Renew License"),
            ),
          ],
        ),
      ),
    );
  }
}


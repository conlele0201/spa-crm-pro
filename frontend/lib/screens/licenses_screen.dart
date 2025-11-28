import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LicensesScreen extends StatefulWidget {
  const LicensesScreen({super.key});

  @override
  State<LicensesScreen> createState() => _LicensesScreenState();
}

class _LicensesScreenState extends State<LicensesScreen> {
  List<dynamic> licenses = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadLicenses();
  }

  Future<void> loadLicenses() async {
    setState(() => loading = true);

    final data = await Supabase.instance.client
        .from("licenses")
        .select("*, spas(name)")
        .order('created_at', ascending: false);

    setState(() {
      licenses = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "License Management",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // TABLE HIỂN THỊ LICENSE
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DataTable(
              columnSpacing: 25,
              columns: const [
                DataColumn(label: Text("Spa Name")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("Expires")),
                DataColumn(label: Text("Created")),
                DataColumn(label: Text("")),
              ],
              rows: licenses.map((item) {
                final spa = item['spas']?['name'] ?? "Unknown";
                final status = item['status'] ?? "unknown";
                final expire = item['expires_at'] ?? "";
                final created = item['created_at'] ?? "";

                return DataRow(cells: [
                  DataCell(Text(spa)),
                  DataCell(Text(status.toUpperCase())),
                  DataCell(Text(expire.toString())),
                  DataCell(Text(created.toString())),
                  DataCell(
                    ElevatedButton(
                      child: const Text("View"),
                      onPressed: () {
                        // sau này làm bước 72 → chi tiết license
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


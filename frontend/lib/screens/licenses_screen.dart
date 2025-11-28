import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'license_detail.dart';

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
        .from('licenses')
        .select('id, spa_id, active, start_date, end_date, spas(name)')
        .order('start_date', ascending: false);

    setState(() {
      licenses = data;
      loading = false;
    });
  }

  String _buildStatus(Map<String, dynamic> item) {
    final bool active = item['active'] ?? false;
    final String? endStr = item['end_date'];
    if (endStr == null) return "NO LICENSE";

    final endDt = DateTime.tryParse(endStr);
    if (endDt == null) return "INVALID";

    final now = DateTime.now();
    if (now.isAfter(endDt)) return "EXPIRED";
    return active ? "ACTIVE" : "INACTIVE";
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (licenses.isEmpty) {
      return const Center(child: Text("No licenses found"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        columns: const [
          DataColumn(label: Text("Spa Name")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Start Date")),
          DataColumn(label: Text("End Date")),
          DataColumn(label: Text("")),
        ],
        rows: licenses.map((item) {
          final spaName = (item['spas']?['name'] ?? 'Unknown').toString();
          final status = _buildStatus(item);
          final start = (item['start_date'] ?? '').toString();
          final end = (item['end_date'] ?? '').toString();

          return DataRow(
            cells: [
              DataCell(Text(spaName)),
              DataCell(
                Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: status == "ACTIVE"
                        ? Colors.green
                        : (status == "EXPIRED" ? Colors.red : Colors.orange),
                  ),
                ),
              ),
              DataCell(Text(start.split('T').first)),
              DataCell(Text(end.split('T').first)),
              DataCell(
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LicenseDetailScreen(
                          licenseId: item['id'].toString(),
                        ),
                      ),
                    );
                  },
                  child: const Text("View"),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

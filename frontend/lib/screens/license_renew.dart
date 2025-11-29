import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LicenseRenewScreen extends StatefulWidget {
  final String licenseId;

  const LicenseRenewScreen({super.key, required this.licenseId});

  @override
  State<LicenseRenewScreen> createState() => _LicenseRenewScreenState();
}

class _LicenseRenewScreenState extends State<LicenseRenewScreen> {
  bool loading = false;
  DateTime? newEndDate;

  Future<void> renewLicense() async {
    if (newEndDate == null) {
      _msg("Please choose new expiration date");
      return;
    }

    setState(() => loading = true);

    await Supabase.instance.client.from("licenses").update({
      'end_date': newEndDate!.toIso8601String(),
      'active': true,
    }).eq("id", widget.licenseId);

    setState(() => loading = false);
    _msg("License renewed successfully");

    Navigator.pop(context, true);
  }

  void _msg(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Renew License")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select New Expiration Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now().add(const Duration(days: 365)),
                );

                if (picked != null) {
                  setState(() => newEndDate = picked);
                }
              },
              child: const Text("Choose Date"),
            ),

            const SizedBox(height: 20),
            Text(
              newEndDate == null
                  ? "No date selected"
                  : "New End Date: ${newEndDate!.toIso8601String().split('T').first}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: loading ? null : renewLicense,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Confirm Renew"),
            ),
          ],
        ),
      ),
    );
  }
}


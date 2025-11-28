import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/license_service.dart';
import '../screens/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) return;

    setState(() => loading = true);

    try {
      // bước 1: đăng nhập supabase
      final res = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: pass);

      final user = res.user;
      if (user == null) {
        showMessage("Login failed.");
        setState(() => loading = false);
        return;
      }

      // bước 2: lấy user profile để biết spa_id
      final profile = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) {
        showMessage("User profile not found.");
        setState(() => loading = false);
        return;
      }

      final spaId = profile['spa_id'];
      if (spaId == null) {
        showMessage("User is not assigned to any spa.");
        setState(() => loading = false);
        return;
      }

      // bước 3: kiểm tra license của SPA
      final licenseService = LicenseService();
      final status = await licenseService.checkLicense(spaId);

      if (status != "OK") {
        switch (status) {
          case "EXPIRED":
            showMessage("License expired. Please renew to continue.");
            break;
          case "NO_LICENSE":
            showMessage("No active license found for this spa.");
            break;
          case "INACTIVE":
            showMessage("License is inactive. Contact admin.");
            break;
          default:
            showMessage("License invalid.");
        }

        setState(() => loading = false);
        return;
      }

      // bước 4: license OK -> vào dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      showMessage("Login error: $e");
    }

    setState(() => loading = false);
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 330,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("SPA CRM PRO LOGIN",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),

              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: loading ? null : login,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

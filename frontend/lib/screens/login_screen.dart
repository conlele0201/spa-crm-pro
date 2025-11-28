import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/license_service.dart';
import 'dashboard.dart';

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

    if (email.isEmpty || pass.isEmpty) {
      showMessage("Please enter email & password");
      return;
    }

    setState(() => loading = true);

    try {
      // 1) Login Supabase
      final result = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: pass);

      final user = result.user;
      if (user == null) {
        showMessage("Login failed.");
        setState(() => loading = false);
        return;
      }

      // 2) Lấy profile người dùng
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
      final role = profile['role'] ?? "staff";

      // 3) Nếu không phải system_admin thì phải kiểm tra license SPA
      if (role != "system_admin") {
        if (spaId == null) {
          showMessage("Your account is not assigned to any Spa.");
          setState(() => loading = false);
          return;
        }

        final licenseService = LicenseService();
        final status = await licenseService.checkLicense(spaId);

        if (status != "OK") {
          switch (status) {
            case "EXPIRED":
              showMessage("License expired. Please renew to continue.");
              break;
            case "NO_LICENSE":
              showMessage("No license found for this Spa.");
              break;
            case "INACTIVE":
              showMessage("Spa license is inactive.");
              break;
            default:
              showMessage("License invalid.");
          }

          setState(() => loading = false);
          return;
        }
      }

      // 4) Lưu role vào session để Sidebar biết
      Supabase.instance.client
          .from('users')
          .update({'last_login': DateTime.now().toIso8601String()})
          .eq('id', user.id);

      // 5) Vào dashboard (role sẽ xử lý menu)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            userRole: role,
            spaId: spaId,
          ),
        ),
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

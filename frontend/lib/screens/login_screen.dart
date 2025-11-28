import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/dashboard.dart';
import '../services/license_service.dart';

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
      // 1. Login Supabase
      final result = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: pass);

      final user = result.user;

      if (user == null) {
        showMessage("Login failed.");
        setState(() => loading = false);
        return;
      }

      // 2. Lấy profile người dùng
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

      final String role = profile['role'] ?? "staff";
      final String? spaId = profile['spa_id'];

      // 3. Nếu không phải system_admin thì kiểm tra license
      if (role != "system_admin") {
        if (spaId == null) {
          showMessage("Your account is not assigned to a Spa.");
          setState(() => loading = false);
          return;
        }

        final licenseService = LicenseService();
        final status = await licenseService.checkLicense(spaId);

        if (status != "OK") {
          showMessage("License error: $status");
          setState(() => loading = false);
          return;
        }
      }

      // 4. Login OK → vào Dashboard
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
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

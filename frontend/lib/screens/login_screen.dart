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
      showMsg("Please enter email & password");
      return;
    }

    setState(() => loading = true);

    try {
      final auth = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: pass);

      final user = auth.user;
      if (user == null) {
        showMsg("Login failed.");
        setState(() => loading = false);
        return;
      }

      // Lấy profile user
      final profile = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) {
        showMsg("User profile not found.");
        setState(() => loading = false);
        return;
      }

      final String role = profile['role'] ?? "staff";
      final String? spaId = profile['spa_id'];

      // Nếu không phải system_admin → kiểm tra license
      if (role != "system_admin") {
        if (spaId == null) {
          showMsg("Your account is not assigned to a Spa.");
          setState(() => loading = false);
          return;
        }

        final licenseService = LicenseService();
        final status = await licenseService.checkLicense(spaId);

        switch (status) {
          case "NO_LICENSE":
            showMsg("This Spa has no license.");
            setState(() => loading = false);
            return;

          case "INACTIVE":
            showMsg("License is disabled.");
            setState(() => loading = false);
            return;

          case "INVALID":
            showMsg("License is invalid.");
            setState(() => loading = false);
            return;

          case "EXPIRED":
            showMsg("License expired. Please renew.");
            setState(() => loading = false);
            return;

          case "OK":
            break; // Cho phép login
        }
      }

      // Login OK → vào dashboard
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
      showMsg("Login error: $e");
    }

    setState(() => loading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 340,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("SPA CRM PRO LOGIN",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
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

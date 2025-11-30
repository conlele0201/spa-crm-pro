import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.SUPABASE_URL,
    anonKey: SupabaseConfig.SUPABASE_ANON_KEY,
  );

  runApp(const SpaCrmApp());
}

class SpaCrmApp extends StatelessWidget {
  const SpaCrmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPA CRM PRO',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/dashboard': (_) =>
            const DashboardScreen(userRole: 'owner'), // có userRole mặc định
      },
    );
  }
}

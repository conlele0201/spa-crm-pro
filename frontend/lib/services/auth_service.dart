import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'supabase_service.dart';

class AuthService {
  static final SupabaseClient _client = SupabaseService.client;

  /// Đăng ký tài khoản (dành cho admin spa – tạo spa mới)
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Đăng nhập
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Đăng xuất
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Lấy user hiện tại
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  /// Lắng nghe thay đổi trạng thái đăng nhập
  Stream<AuthState> onAuthStateChange() {
    return _client.auth.onAuthStateChange;
  }
}


import 'package:flutter/material.dart';
import '../models/treatment_session_model.dart';
import '../services/treatment_session_service.dart';

class TreatmentSessionController extends ChangeNotifier {
  final TreatmentSessionService _service = TreatmentSessionService();

  List<TreatmentSessionModel> sessionList = [];
  bool loading = false;

  /// Load toàn bộ buổi liệu trình của 1 spa
  Future<void> loadSessions(String spaId) async {
    loading = true;
    notifyListeners();

    sessionList = await _service.getSessions(spaId);

    loading = false;
    notifyListeners();
  }

  /// Thêm buổi liệu trình
  Future<void> addSession(TreatmentSessionModel session) async {
    await _service.addSession(session);
    await loadSessions(session.spaId);
  }

  /// Cập nhật buổi liệu trình
  Future<void> updateSession(String id, TreatmentSessionModel session) async {
    await _service.updateSession(id, session);
    await loadSessions(session.spaId);
  }

  /// Xóa buổi liệu trình
  Future<void> deleteSession(String id, String spaId) async {
    await _service.deleteSession(id);
    await loadSessions(spaId);
  }
}


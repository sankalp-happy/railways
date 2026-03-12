import 'dart:convert';
import '../models/audit_log.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _api = ApiService();

  /// Fetches document-related audit logs to serve as notifications.
  /// Falls back to empty list on error (non-admin users get 403).
  Future<List<AuditLog>> getNotifications() async {
    // Try document logs first (admin only)
    var response = await _api.get('/logs/documents/');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded is List ? decoded : (decoded['results'] as List);
      return data.map((l) => AuditLog.fromJson(l)).toList();
    }

    // For non-admin users, derive notifications from dump
    response = await _api.get('/dump/');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final docs = data['documents'] as List;
      // Convert recent documents into pseudo-notifications
      return docs.map((d) => AuditLog(
        id: 0,
        action: 'document_available',
        targetType: 'document',
        targetId: d['document_id'],
        metadata: {'name': d['name'], 'version': d['version']},
        createdAt: DateTime.parse(d['last_updated']),
      )).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return [];
  }
}

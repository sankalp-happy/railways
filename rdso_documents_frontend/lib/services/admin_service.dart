import 'dart:convert';
import '../models/user.dart';
import '../models/audit_log.dart';
import 'api_service.dart';

class AdminService {
  final ApiService _api = ApiService();

  Future<List<User>> getRegistrations({String? filter}) async {
    final params = <String, String>{};
    if (filter != null) params['filter'] = filter;

    final response = await _api.get('/registrations/', queryParams: params.isNotEmpty ? params : null);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((u) => User.fromJson(u)).toList();
    }
    return [];
  }

  Future<User?> updateUserStatus(String hrmsId, String status) async {
    final response = await _api.post('/update_status/', body: {
      'HRMS_ID': hrmsId,
      'status': status,
    });
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<List<AuditLog>> getDocumentLogs() async {
    final response = await _api.get('/logs/documents/');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((l) => AuditLog.fromJson(l)).toList();
    }
    return [];
  }

  Future<List<AuditLog>> getUserLogs() async {
    final response = await _api.get('/logs/users/');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((l) => AuditLog.fromJson(l)).toList();
    }
    return [];
  }
}

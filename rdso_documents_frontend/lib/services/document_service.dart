import 'dart:convert';
import '../models/document.dart';
import '../models/category.dart';
import 'api_service.dart';

class DocumentService {
  final ApiService _api = ApiService();

  Future<List<Document>> getDocuments({List<String>? documentIds}) async {
    final params = <String, String>{};
    if (documentIds != null && documentIds.isNotEmpty) {
      params['document_ids'] = documentIds.join(',');
    }

    final response = await _api.get('/documents/', queryParams: params.isNotEmpty ? params : null);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((d) => Document.fromJson(d)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getDump({DateTime? lastSynced}) async {
    final params = <String, String>{};
    if (lastSynced != null) {
      params['last_synced'] = lastSynced.toIso8601String();
    }

    final response = await _api.get('/dump/', queryParams: params.isNotEmpty ? params : null);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'documents': (data['documents'] as List).map((d) => Document.fromJson(d)).toList(),
        'categories': (data['categories'] as List).map((c) => Category.fromJson(c)).toList(),
        'timestamp': data['timestamp'],
      };
    }
    return {'documents': <Document>[], 'categories': <Category>[], 'timestamp': null};
  }

  Future<List<Document>> getDocumentsByCategory(String categoryName) async {
    final allDocs = await getDocuments();
    return allDocs.where((doc) => doc.categories.any((c) => c.name == categoryName)).toList();
  }

  Future<List<Document>> searchDocuments(String query) async {
    final allDocs = await getDocuments();
    final q = query.toLowerCase();
    return allDocs.where((doc) =>
        doc.name.toLowerCase().contains(q) ||
        doc.documentId.toLowerCase().contains(q)).toList();
  }

  Future<Document?> createDocument({
    required String documentId,
    required String name,
    required String version,
    required String link,
    required String internalLink,
    List<String> categoryNames = const [],
  }) async {
    final response = await _api.post('/create_document/', body: {
      'document_id': documentId,
      'name': name,
      'version': version,
      'link': link,
      'internal_link': internalLink,
      'category_names': categoryNames,
    });
    if (response.statusCode == 201) {
      return Document.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}

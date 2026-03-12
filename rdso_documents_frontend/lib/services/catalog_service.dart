import 'dart:convert';
import 'dart:developer' as developer;
import '../models/category.dart';
import '../models/subhead.dart';
import '../models/document.dart';
import 'api_service.dart';

class CatalogService {
  final ApiService _api = ApiService();

  Future<List<Category>> getCategories() async {
    developer.log('CatalogService: fetching categories', name: 'catalog');
    final response = await _api.get('/categories/');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded is List ? decoded : (decoded['results'] as List);
      developer.log('CatalogService: received ${data.length} categories', name: 'catalog');
      return data.map((c) => Category.fromJson(c)).toList();
    }
    developer.log('CatalogService: failed to fetch categories (${response.statusCode})', name: 'catalog');
    return [];
  }

  Future<List<Subhead>> getSubheads(int categoryId) async {
    developer.log('CatalogService: fetching subheads for category $categoryId', name: 'catalog');
    final response = await _api.get('/categories/$categoryId/subheads/');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded is List ? decoded : (decoded['results'] as List);
      developer.log('CatalogService: received ${data.length} subheads', name: 'catalog');
      return data.map((s) => Subhead.fromJson(s)).toList();
    }
    developer.log('CatalogService: failed to fetch subheads (${response.statusCode})', name: 'catalog');
    return [];
  }

  Future<List<Document>> getDocumentsBySubhead(int subheadId) async {
    developer.log('CatalogService: fetching documents for subhead $subheadId', name: 'catalog');
    final response = await _api.get('/subheads/$subheadId/documents/');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded is List ? decoded : (decoded['results'] as List);
      developer.log('CatalogService: received ${data.length} documents', name: 'catalog');
      return data.map((d) => Document.fromJson(d)).toList();
    }
    developer.log('CatalogService: failed to fetch documents (${response.statusCode})', name: 'catalog');
    return [];
  }
}

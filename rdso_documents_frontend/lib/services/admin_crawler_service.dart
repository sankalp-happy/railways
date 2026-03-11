import 'dart:convert';
import 'dart:developer' as developer;
import 'api_service.dart';

class AdminCrawlerService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> runCrawler() async {
    developer.log('AdminCrawlerService: triggering crawler', name: 'admin');
    final response = await _api.post('/admin/run-crawler/');
    developer.log('AdminCrawlerService: runCrawler status=${response.statusCode}', name: 'admin');
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getCrawlerStatus() async {
    developer.log('AdminCrawlerService: fetching crawler status', name: 'admin');
    final response = await _api.get('/admin/crawler-status/');
    developer.log('AdminCrawlerService: status=${response.statusCode}', name: 'admin');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {'running': false, 'pid': null, 'last_run': null};
  }

  Future<Map<String, dynamic>> getCrawlerLogs({int since = 0}) async {
    final response = await _api.get('/admin/crawler-logs/?since=$since');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {'running': false, 'offset': since, 'lines': []};
  }

  Future<Map<String, dynamic>> importCatalog() async {
    developer.log('AdminCrawlerService: triggering import', name: 'admin');
    final response = await _api.post('/admin/import-catalog/');
    developer.log('AdminCrawlerService: import status=${response.statusCode}', name: 'admin');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {'status': 'error', 'output': 'Import failed (${response.statusCode})'};
  }
}

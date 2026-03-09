import 'dart:convert';
import '../models/post.dart';
import 'api_service.dart';

class PostService {
  final ApiService _api = ApiService();

  Future<Post?> createPost({
    required String documentId,
    required String content,
    required String postType,
    int? parentId,
  }) async {
    final response = await _api.post('/create_post/', body: {
      'document_id': documentId,
      'content': content,
      'post_type': postType,
      if (parentId != null) 'parent': parentId,
    });

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<List<Post>> getPosts(String documentId) async {
    final response = await _api.get('/posts/', queryParams: {'document_id': documentId});
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((p) => Post.fromJson(p)).toList();
    }
    return [];
  }

  Future<List<Post>> getFeedback(String documentId) async {
    final response = await _api.get('/feedback/$documentId/');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((p) => Post.fromJson(p)).toList();
    }
    return [];
  }
}

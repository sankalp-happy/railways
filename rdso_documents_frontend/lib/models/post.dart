class Post {
  final int id;
  final String userHrmsId;
  final String postType;
  final String content;
  final DateTime createdAt;
  final String documentId;
  final int? parentId;

  Post({
    required this.id,
    required this.userHrmsId,
    required this.postType,
    required this.content,
    required this.createdAt,
    required this.documentId,
    this.parentId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userHrmsId: json['user_hrms_id'],
      postType: json['post_type'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      documentId: json['document_id'],
      parentId: json['parent'],
    );
  }
}

class AuditLog {
  final int id;
  final String? userHrmsId;
  final String action;
  final String targetType;
  final String targetId;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  AuditLog({
    required this.id,
    this.userHrmsId,
    required this.action,
    required this.targetType,
    required this.targetId,
    required this.metadata,
    required this.createdAt,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: json['id'],
      userHrmsId: json['user_hrms_id'],
      action: json['action'],
      targetType: json['target_type'],
      targetId: json['target_id'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get actionLabel {
    switch (action) {
      case 'user_login':
        return 'User Login';
      case 'user_status_change':
        return 'User Status Change';
      case 'document_create':
        return 'New Document Added';
      case 'document_view':
        return 'Document Viewed';
      case 'post_create':
        return 'New Feedback/Comment';
      case 'batch_action':
        return 'Batch Action';
      default:
        return action;
    }
  }
}

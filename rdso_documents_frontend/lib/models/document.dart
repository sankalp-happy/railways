import 'category.dart';

class Document {
  final String documentId;
  final String name;
  final String version;
  final String link;
  final String internalLink;
  final List<Category> categories;
  final DateTime lastUpdated;
  final int? drawingId;
  final String? description;
  final String? contentType;
  final int? fileSize;
  final bool isArchived;
  final int? subheadId;

  Document({
    required this.documentId,
    required this.name,
    required this.version,
    required this.link,
    required this.internalLink,
    required this.categories,
    required this.lastUpdated,
    this.drawingId,
    this.description,
    this.contentType,
    this.fileSize,
    this.isArchived = false,
    this.subheadId,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentId: json['document_id'] ?? '',
      name: json['name'] ?? '',
      version: json['version'] ?? 'Current',
      link: json['link'] ?? '',
      internalLink: json['internal_link'] ?? '',
      categories: (json['category'] as List? ?? [])
          .map((c) => Category.fromJson(c))
          .toList(),
      lastUpdated: DateTime.parse(json['last_updated']),
      drawingId: json['drawing_id'],
      description: json['description'],
      contentType: json['content_type'],
      fileSize: json['file_size'],
      isArchived: json['is_archived'] ?? false,
      subheadId: json['subhead'],
    );
  }
}

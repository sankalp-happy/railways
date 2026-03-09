import 'category.dart';

class Document {
  final String documentId;
  final String name;
  final String version;
  final String link;
  final String internalLink;
  final List<Category> categories;
  final DateTime lastUpdated;

  Document({
    required this.documentId,
    required this.name,
    required this.version,
    required this.link,
    required this.internalLink,
    required this.categories,
    required this.lastUpdated,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentId: json['document_id'],
      name: json['name'],
      version: json['version'],
      link: json['link'],
      internalLink: json['internal_link'],
      categories: (json['category'] as List? ?? [])
          .map((c) => Category.fromJson(c))
          .toList(),
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }
}

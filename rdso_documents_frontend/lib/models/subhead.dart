class Subhead {
  final int id;
  final String name;
  final int categoryId;
  final String? categoryName;
  final String? crawlerId;
  final int drawingCount;

  Subhead({
    required this.id,
    required this.name,
    required this.categoryId,
    this.categoryName,
    this.crawlerId,
    required this.drawingCount,
  });

  factory Subhead.fromJson(Map<String, dynamic> json) {
    return Subhead(
      id: json['id'],
      name: json['name'],
      categoryId: json['category'],
      categoryName: json['category_name'],
      crawlerId: json['crawler_id'],
      drawingCount: json['drawing_count'] ?? 0,
    );
  }
}

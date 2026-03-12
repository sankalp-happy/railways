class Category {
  final int id;
  final String name;
  final int? subheadCount;
  final int? drawingCount;

  Category({required this.id, required this.name, this.subheadCount, this.drawingCount});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      subheadCount: json['subhead_count'],
      drawingCount: json['drawing_count'],
    );
  }
}

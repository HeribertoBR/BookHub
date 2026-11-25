class Book {
  final String id;
  final String title;
  final String path;
  final int lastPage;
  final int totalPages;

  const Book({
    required this.id,
    required this.title,
    required this.path,
    this.lastPage = 0,
    this.totalPages = 0,
  });

  double progressAtPage(int page, {int? pageCount}) {
    final count = pageCount ?? totalPages;
    if (count <= 0) return 0;
    return (page + 1).clamp(0, count) / count;
  }

  double get readingProgress => progressAtPage(lastPage);

  int get readingProgressPercent => (readingProgress * 100).round();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'path': path,
      'lastPage': lastPage,
      'totalPages': totalPages,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      path: json['path'] as String,
      lastPage: json['lastPage'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}

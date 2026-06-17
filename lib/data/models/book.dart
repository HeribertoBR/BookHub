class Book {
    final String id;
    final String title;
    final String path;
    final int lastPage;

    const Book({
        required this.id,
        required this.title,
        required this.path,
        this.lastPage = 0,
    });

    Map<String, dynamic> toJson(){
        return {
            'id': id,
            'title': title,
            'path': path,
            'lastPage': lastPage,
        };
    }

    factory Book.fromJson(Map<String, dynamic> json) {
        return Book(
            id: json['id'] as String,
            title: json['title'] as String,
            path: json['path'] as String,
            lastPage: json['lastPage'] as int? ?? 0,
        );
    }
}

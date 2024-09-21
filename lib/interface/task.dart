class Task {
  final String id;
  final String title;
  final String description;
  final String thumbnail;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
  });

  // Conversión de Map para Firebase Database
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
    };
  }

  // Conversión de Map desde Firebase Database
  static Task fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
    );
  }
}

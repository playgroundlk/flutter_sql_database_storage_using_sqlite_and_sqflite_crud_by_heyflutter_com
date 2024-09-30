class Todo {
  final int id;
  final String title;
  final String createdAt;
  final String? updatedAt;

  Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Todo.fromSqfliteDatabase(Map<String, dynamic> map) => Todo(
        id: map['id']?.toInt() ?? 0,
        title: map['title'] ?? '',
        createdAt: DateTime.fromMicrosecondsSinceEpoch(map['created_at']).toIso8601String(),
        updatedAt: map['updated_at'] == null ? null : DateTime.fromMicrosecondsSinceEpoch(map['updated_at']).toIso8601String(),
      );
}

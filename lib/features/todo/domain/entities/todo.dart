class Todo {
  final int id;
  final String title;
  final bool completed;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const Todo({
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
    required this.expiresAt
  });
}
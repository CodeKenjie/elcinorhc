class Plan {
  final int id;
  final String title;
  final String? body;
  final bool completed;
  final DateTime createdAt;
  final DateTime dueAt;

  const Plan({
    required this.id,
    required this.title,
    required this.body,
    required this.completed,
    required this.createdAt,
    required this.dueAt
  });

  Plan copyWith({
    String? title,
    String? body,
    bool? completed,
    DateTime? dueAt
  }) {
    return Plan(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      completed: completed ?? this.completed,
      createdAt: createdAt,
      dueAt: dueAt ?? this.dueAt
    );
  }
}
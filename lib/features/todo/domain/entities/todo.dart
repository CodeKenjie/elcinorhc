class Todo {
  final int id;
  final int? planId;
  final String title;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final DateTime? expiresAt;
  final bool completed;
  final DateTime? completedAt;
  final DateTime createdAt;

  const Todo({
    required this.id,
    required this.planId,
    required this.title,
    required this.startsAt,
    required this.endsAt,
    required this.expiresAt,
    required this.completed,
    required this.completedAt,
    required this.createdAt,
  });

  Todo copyWith({
    int? planId,
    String? title,
    DateTime? startsAt,
    DateTime? endsAt,
    DateTime? expiresAt,
    bool? completed,
    DateTime? completedAt
  }){
    return Todo (
      id: id,
      planId: planId ?? this.planId,
      title: title ?? this.title,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      expiresAt: expiresAt ?? this.expiresAt,
      completed: completed ?? this.completed,
      completedAt: completedAt,
      createdAt:  createdAt,
    );
  }
}
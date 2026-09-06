class Journal {
  final int id;
  final String title;
  final String body;
  final DateTime createdAt;

  const Journal({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt
  });

  Journal copyWith({
    String? title,
    String? body
  }){
    return Journal(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt
    );
  }
}
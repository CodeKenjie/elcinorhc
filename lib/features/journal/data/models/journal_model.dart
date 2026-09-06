import '../../domain/entities/journal.dart';

class JournalModel extends Journal {
  const JournalModel({
    required super.id,
    required super.title,
    required super.body,
    required super.createdAt
  });

  factory JournalModel.fromEntity(Journal plan) {
    return JournalModel(
      id: plan.id, 
      title: plan.title, 
      body: plan.body, 
      createdAt: plan.createdAt
    );
  }
}
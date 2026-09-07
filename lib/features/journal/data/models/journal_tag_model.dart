import '../../domain/entities/journal_tag.dart';

class JournalTagModel extends JournalTag {
  const JournalTagModel({
    required super.id,
    required super.tagId,
    required super.journalId
  });

  factory JournalTagModel.fromEntity({
    required int id,
    required int tagId,
    required int journalId
  }) {
    return JournalTagModel(
      id: id,
      tagId: tagId,
      journalId: journalId
    );
  }
}
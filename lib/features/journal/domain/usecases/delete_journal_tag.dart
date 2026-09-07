import '../repositories/journal_tag_repository.dart';

class DeleteJournalTag {
  final JournalTagRepository repository;

  DeleteJournalTag(this.repository);

  Future<void> call({ required int journalId, required int tagId}) async {
    return await repository.deleteJournalTag(journalId: journalId, tagId: tagId);
  }
}
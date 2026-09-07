import '../repositories/journal_tag_repository.dart';
import '../entities/journal_tag.dart';

class CreateJournalTag {
  final JournalTagRepository repository;

  CreateJournalTag(this.repository);

  Future<JournalTag> call({ required int tagId, required int journalId }) async {
    return await repository.addJournalTag( tagId: tagId, journalId: journalId );
  }
}
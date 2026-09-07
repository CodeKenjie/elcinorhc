import '../repositories/journal_tag_repository.dart';
import '../entities/journal_tag.dart';

class GetAllJournalTags {
  final JournalTagRepository repository;

  GetAllJournalTags(this.repository);

  Future<List<JournalTag>> call(int journalId) async {
    return await repository.getJournalTag(journalId);
  }
}
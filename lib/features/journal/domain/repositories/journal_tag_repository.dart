import '../entities/journal_tag.dart';

abstract class JournalTagRepository {
  Future<List<JournalTag>> getJournalTag(int journalId);

  Future<JournalTag> addJournalTag({ required int tagId, required int journalId });

  Future<void> deleteJournalTag({ required int journalId, required int tagId });
}
import '../data_sources/journal_tag_local_data_source.dart';
import '../../domain/entities/journal_tag.dart';
import '../../domain/repositories/journal_tag_repository.dart';

class JournalTagRepositoryImpl implements JournalTagRepository {
  final JournalTagLocalDataSource localDataSource;

  const JournalTagRepositoryImpl(this.localDataSource);

  @override
  Future<List<JournalTag>> getJournalTag(int journalId) {
    return localDataSource.getJournalTag(journalId);
  }

  @override
  Future<JournalTag> addJournalTag({ required int tagId, required int journalId }) {
    return localDataSource.addJournalTag(tagId: tagId, journalId: journalId);
  }

  @override
  Future<void> deleteJournalTag({ required int journalId, required int tagId }) {
    return localDataSource.deleteJournalTag(journalId: journalId, tagId: tagId);
  }
}
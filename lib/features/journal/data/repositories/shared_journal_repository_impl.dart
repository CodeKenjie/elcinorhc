
import '../../domain/entities/shared_journal.dart';
import '../../domain/entities/journal.dart';
import '../../data/models/journal_model.dart';
import '../../domain/repositories/shared_journal_repository.dart';
import '../data_sources/shared_journal_remote_data_source.dart';

class SharedJournalRepositoryImpl implements SharedJournalRepository {
  final SharedJournalRemoteDataSource remoteDataSource;

  const SharedJournalRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SharedJournal>> getSharedJournals() {
    return remoteDataSource.getSharedJournals();
  }

  @override
  Future<SharedJournal> shareJournal({
    required String userUid,
    required Journal journal
  }) {
    return remoteDataSource.shareJournal(
      userUid: userUid, 
      journal: JournalModel.fromEntity(journal)
    );
  }

  @override
  Future<void> updateSharedJournal({
    required String sharedJournalUid,
    required String title,
    required String body
  }) {
    return remoteDataSource.updateSharedJournal(sharedJournalUid: sharedJournalUid, title: title, body: body);
  }

  @override
  Future<void> deleteSharedJournal(String journalUid){
    return remoteDataSource.deleteSharedJournal(journalUid);
  }
}
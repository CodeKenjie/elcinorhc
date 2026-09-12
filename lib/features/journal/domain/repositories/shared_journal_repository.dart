import '../entities/shared_journal.dart';
import '../entities/journal.dart';

abstract class SharedJournalRepository {
  Future<List<SharedJournal>> getSharedJournals();

  Future<SharedJournal> shareJournal({
    required String userUid,
    required Journal journal, 
  });

  Future<void> updateSharedJournal({
    required String sharedJournalUid,
    required String title,
    required String body
  });

  Future<void> deleteSharedJournal(String sharedJournalUid);
}
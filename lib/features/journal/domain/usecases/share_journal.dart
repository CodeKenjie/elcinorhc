import '../entities/shared_journal.dart';
import '../entities/journal.dart';
import '../repositories/shared_journal_repository.dart';

class ShareJournal {
  final SharedJournalRepository repository;

  const ShareJournal(this.repository);

  Future<SharedJournal> call ({
    required String userUid,
    required Journal journal
  }) {
    return repository.shareJournal(
      userUid: userUid, 
      journal: journal
    );
  }
}
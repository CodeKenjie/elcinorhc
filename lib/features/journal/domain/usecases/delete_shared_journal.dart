import '../repositories/shared_journal_repository.dart';

class DeleteSharedJournal {
  final SharedJournalRepository repository;

  const DeleteSharedJournal(this.repository);

  Future<void> call(String sharedJournalUid) {
    return repository.deleteSharedJournal(sharedJournalUid);
  }
}
import '../repositories/shared_journal_repository.dart';

class UpdateSharedJournal {
  final SharedJournalRepository repository;

  const UpdateSharedJournal(this.repository);

  Future<void> call ({
    required String sharedJournalUid,
    required String title,
    required String body,
  }) {
    return repository.updateSharedJournal(
      sharedJournalUid: sharedJournalUid, 
      title: title, 
      body: body
    );
  }
}
import '../entities/shared_journal.dart';
import '../repositories/shared_journal_repository.dart';

class GetSharedJournal {
  final SharedJournalRepository repository;
  const GetSharedJournal(this.repository);

  Future<List<SharedJournal>> call () {
    return repository.getSharedJournals();
  }
}
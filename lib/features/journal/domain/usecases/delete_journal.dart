import '../repositories/journal_repository.dart';

class DeleteJournal {
  final JournalRepository repository;

  const DeleteJournal(this.repository);

  Future<void> call (int id) {
    return repository.deleteJournal(id);
  }
}
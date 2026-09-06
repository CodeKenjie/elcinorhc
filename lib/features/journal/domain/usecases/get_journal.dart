import '../repositories/journal_repository.dart';
import '../entities/journal.dart';

class GetJournal {
  final JournalRepository repository;

  const GetJournal(this.repository);

  Future<Journal?> call(int id) {
    return repository.getJournal(id);
  }
}
import '../repositories/journal_repository.dart';
import '../entities/journal.dart';

class GetJournals {
  final JournalRepository repository;

  const GetJournals(this.repository);

  Future<List<Journal>> call () {
    return repository.getJournals();
  }
}
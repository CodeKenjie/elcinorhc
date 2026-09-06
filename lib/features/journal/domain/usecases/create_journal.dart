import '../repositories/journal_repository.dart';
import '../entities/journal.dart';

class CreateJournal {
  final JournalRepository repository;

  const CreateJournal(this.repository);

  Future<Journal> call({
    required String title,
    required String body
  }) {
    return repository.addJournal(
      title: title, 
      body: body
    );
  }
}
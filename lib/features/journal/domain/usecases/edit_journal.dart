import '../repositories/journal_repository.dart';

class EditJournal {
  final JournalRepository repository;

  const EditJournal(this.repository);

  Future<void> call ({ 
    required int id, 
    required String title, 
    required String body 
  }) {
    return repository.editJournal(
      id: id, 
      title: title, 
      body: body
    );
  }
}
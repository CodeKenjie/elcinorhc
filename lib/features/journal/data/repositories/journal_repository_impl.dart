import '../data_sources/journal_local_data_source.dart';
import '../../domain/entities/journal.dart';
import '../../domain/repositories/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource localDataSource;

  const JournalRepositoryImpl(this.localDataSource);

  @override
  Future<List<Journal>> getJournals() {
    return localDataSource.getJournals();
  }

  @override
  Future<Journal> getJournal(int id) {
    return localDataSource.getJournal(id);
  }

  @override
  Future<Journal> addJournal({ required String title, required String body }) {
    return localDataSource.addJournal(title: title, body: body);
  }

  @override
  Future<void> editJournal({ required int id, required String title, required String body }) {
    return localDataSource.editJournal(id: id, title: title, body: body);
  }

  @override
  Future<void> deleteJournal(int id) {
    return localDataSource.deleteJournal(id);
  }

  @override
  Future<List<Journal>> getEntriesBetween({ required DateTime start, required DateTime end }) {
    return localDataSource.getEntriesBetween(start: start, end: end);
  }
}
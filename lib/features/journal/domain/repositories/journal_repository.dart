import '../entities/journal.dart';

abstract class JournalRepository {
  Future<List<Journal>> getJournals();
  
  Future<Journal> getJournal(int id);

  Future<Journal> addJournal({ required String title, required String body });

  Future<void> editJournal({ required int id, required String title, required String body });

  Future<void> deleteJournal(int id);

  Future<List<Journal>> getEntriesBetween({ required DateTime start, required DateTime end });
}
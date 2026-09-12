import 'package:drift/drift.dart';
import '../../../../core/database/local/local_database.dart';
import '../models/journal_model.dart';

class JournalLocalDataSource {
  final LocalDatabase localDatabase;

  JournalLocalDataSource(this.localDatabase);

  Future<List<JournalModel>> getJournals() async {
    final journals = await localDatabase.select(localDatabase.journals).get();
    return journals.map((journal) => JournalModel(
        id: journal.id,
        title: journal.title,
        body: journal.body,
        createdAt: journal.createdAt
    )).toList();
  }

  Future<JournalModel> getJournal(int id) async {
    final journal = await (localDatabase.select(localDatabase.journals)..where((journal) => journal.id.equals(id))).getSingle();

    return JournalModel(
      id: journal.id, 
      title: journal.title, 
      body: journal.body, 
      createdAt: journal.createdAt
    );
  }

  Future<JournalModel> addJournal({ required String title, required String body }) async {
    final id = await localDatabase.into(localDatabase.journals).insert(
      JournalsCompanion.insert(
        title: title, 
        body: body
      )
    );

    final journal = await (localDatabase.select(localDatabase.journals)..where((journal) => journal.id.equals(id))).getSingle();

    return JournalModel(
      id: journal.id, 
      title: journal.title, 
      body: journal.body, 
      createdAt: journal.createdAt
    );
  }

  Future<int> editJournal({ required int id, required String title, required String body }) async {
    return await (localDatabase.update(localDatabase.journals)..where((journal) => journal.id.equals(id))).write(
      JournalsCompanion(
        title: Value(title),
        body: Value(body),
      )
    );
  }

  Future<int> deleteJournal(int id) async {
    return await (localDatabase.delete(localDatabase.journals)..where((journal) => journal.id.equals(id))).go();
  }

  Future<List<JournalModel>> getEntriesBetween({ required DateTime start, required DateTime end }) async {
    final journals = await (localDatabase.select(localDatabase.journals)..where((journal) => journal.createdAt.isBiggerOrEqualValue(start) & journal.createdAt.isSmallerOrEqualValue(end))).get();

    return journals.map((journal) => JournalModel(
      id: journal.id, 
      title: journal.title, 
      body: journal.body, 
      createdAt: journal.createdAt
    )).toList();
  }
}
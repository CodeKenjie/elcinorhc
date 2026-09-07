import 'package:drift/drift.dart';
import 'package:elcinorch/core/database/local/local_database.dart';
import '../models/journal_tag_model.dart';

class JournalTagLocalDataSource {
  final LocalDatabase localDatabase;
  const JournalTagLocalDataSource(this.localDatabase);

  Future<List<JournalTagModel>> getJournalTag(int journalId) async {
    final journals = await (localDatabase.select(localDatabase.journalTags)..where((journalTag) => journalTag.id.equals(journalId))).get();
    return journals.map((journal) => JournalTagModel(
      id: journal.id, 
      tagId: journal.tagId,
      journalId: journal.journalId
    )).toList();
  }

  Future<JournalTagModel> addJournalTag({ required int tagId, required int journalId }) async {
    final id = await localDatabase.into(localDatabase.journalTags).insert(
      JournalTagsCompanion.insert(
        journalId: journalId, 
        tagId: tagId
      )
    );

    final journalTag = await (localDatabase.select(localDatabase.journalTags)..where((journalTag) => journalTag.id.equals(id))).getSingle();

    return JournalTagModel(
      id: journalTag.id,
      tagId: journalTag.tagId,
      journalId: journalTag.journalId
    );
  }

  Future<int> deleteJournalTag({ required int journalId, required int tagId}) async {
    return await (localDatabase.delete(localDatabase.journalTags)..where((journalTag) => journalTag.journalId.equals(journalId) & journalTag.tagId.equals(tagId))).go();
  }
}
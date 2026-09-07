import '../models/tag_model.dart';
import 'package:elcinorch/core/database/local/local_database.dart';

class TagLocalDataSource {
  final LocalDatabase localDatabase;

  const TagLocalDataSource(this.localDatabase);

  Future<List<TagModel>> getTags() async {
    final tags = await localDatabase.select(localDatabase.tags).get();
    return tags.map((tag) => TagModel(
      id: tag.id,
      name: tag.name
    )).toList();
  }

  Future<List<TagModel>> getJournalTags(int journalId) async {
    final subquery = localDatabase.selectOnly(localDatabase.journalTags)..addColumns([localDatabase.journalTags.tagId])..where(localDatabase.journalTags.journalId.equals(journalId));
    final tagIds = await subquery.map((row) => row.read(localDatabase.journalTags.tagId)!).get();
    final  tags = await (localDatabase.select(localDatabase.tags)..where((tag) => tag.id.isIn(tagIds))).get();
    return tags.map((tag) => TagModel(
      id: tag.id, 
      name: tag.name
    )).toList();
  }

  Future<TagModel> getTag(int id) async {
    final tag = await (localDatabase.select(localDatabase.tags)..where((tag) => tag.id.equals(id))).getSingle();
    return TagModel(
      id: tag.id,
      name: tag.name
    );
  }

  Future<TagModel> addTag({ required String name }) async {
    final id = await localDatabase.into(localDatabase.tags).insert(
      TagsCompanion.insert(name: name)
    );

    return getTag(id);
  }

  Future<int> deleteTag(int id) async {
    return await (localDatabase.delete(localDatabase.tags)..where((tag) => tag.id.equals(id))).go();
  }
}
import '../entities/tag.dart';

abstract class TagRepository {
  Future<List<Tag>> getTags();

  Future<List<Tag>> getJournalTags(int journalId);

  Future<Tag> getTag(int id);

  Future<Tag> addTag({ required String name });

  Future<void> deleteTag(int id);
}
import '../../domain/entities/tag.dart';
import '../../domain/repositories/tag_repository.dart';
import '../data_sources/tag_local_data_source.dart';

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource localDataSource;

  const TagRepositoryImpl(this.localDataSource);

  @override
  Future<List<Tag>> getTags() {
    return localDataSource.getTags();
  }

  @override
  Future<List<Tag>> getJournalTags(int journalId) {
    return localDataSource.getJournalTags(journalId);
  }

  @override
  Future<Tag> getTag(int id) {
    return localDataSource.getTag(id);
  }

  @override
  Future<Tag> addTag({ required String name }) {
    return localDataSource.addTag(name: name);
  }

  @override
  Future<void> deleteTag(int id) {
    return localDataSource.deleteTag(id);
  }
}
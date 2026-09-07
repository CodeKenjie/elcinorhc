import '../repositories/tag_repository.dart';
import '../entities/tag.dart';

class GetJournalTags {
  final TagRepository repository;
  const GetJournalTags(this.repository);

  Future<List<Tag>> call(int journalId) async {
    return await repository.getJournalTags(journalId);
  }
}
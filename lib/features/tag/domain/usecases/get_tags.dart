import '../repositories/tag_repository.dart';
import '../entities/tag.dart';

class GetTags {
  final TagRepository repository;

  GetTags(this.repository);

  Future<List<Tag>> call () {
    return repository.getTags();
  }
}
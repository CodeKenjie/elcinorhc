import '../repositories/tag_repository.dart';
import '../entities/tag.dart';

class GetTag {
  final TagRepository repository;

  GetTag(this.repository);

  Future<Tag> call (int id) {
    return repository.getTag(id);
  }
}
import '../repositories/tag_repository.dart';
import '../entities/tag.dart';

class CreateTag {
  final TagRepository repository;

  CreateTag(this.repository);

  Future<Tag> call ({ required String name }) {
    return repository.addTag(name: name);
  }
}
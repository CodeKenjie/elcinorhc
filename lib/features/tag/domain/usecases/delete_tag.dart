import '../repositories/tag_repository.dart';

class DeleteTag {
  final TagRepository repository;

  DeleteTag(this.repository);

  Future<void> call (int id) {
    return repository.deleteTag(id);
  }
}
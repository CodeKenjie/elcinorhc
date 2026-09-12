import '../repositories/todo_repository.dart';

class Update {
  final TodoRepository repository;

  const Update(this.repository);
  Future<void> call({
    required int id, 
    int? planId, 
    required String title, 
    DateTime? startsAt,
    DateTime? endsAt,
    DateTime? expiresAt 
  }) {
    return repository.updateTodo(
      id: id, 
      planId: planId,  
      title: title, 
      startsAt: startsAt,
      endsAt: endsAt,
      expiresAt: expiresAt
    );
  }
}

import '../repositories/plan_repository.dart';

class UpdatePlan {
  final PlanRepository repository;
  const UpdatePlan(this.repository);

  Future<void> call ({
    required int id,
    required String title,
    String? body,
    required DateTime dueAt,
  }) {
    return repository.updatePlan(
      id: id, 
      title: title, 
      body: body, 
      dueAt: dueAt
    );
  }
}
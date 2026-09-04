import '../repositories/plan_repository.dart';

class DeletePlan {
  final PlanRepository repository;

  const DeletePlan(this.repository);

  Future<void> call (int id) {
    return repository.deletePlan(id);
  }
}
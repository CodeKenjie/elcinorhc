import '../repositories/plan_repository.dart';
import '../entities/plan.dart';

class CreatePlan {
  final PlanRepository repository;
  const CreatePlan(this.repository);

  Future<Plan> call({
    required String title,
    required String? body,
    required DateTime dueAt
  }) {
    return repository.addPlan(
      title: title, 
      body: body, 
      dueAt: dueAt
    );
  }
}
import '../repositories/plan_repository.dart';
import '../entities/plan.dart';

class GetPlans {
  final PlanRepository repository;

  const GetPlans(this.repository);

  Future<List<Plan>> call () {
    return repository.getPlans();
  }
}
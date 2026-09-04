import '../repositories/plan_repository.dart';

class UpdatePlanStatus {
  final PlanRepository repository;

  const UpdatePlanStatus(this.repository);

  Future<void> call({
    required int id,
    required bool completed
  }){
    return repository.updatePlanStatus(
      id: id, 
      completed: completed
    );
  }
}
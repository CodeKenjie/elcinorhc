import '../data_sources/plan_local_data_source.dart';
import '../../domain/repositories/plan_repository.dart';
import '../../domain/entities/plan.dart';

class PlanRepositoryImpl implements PlanRepository {
  final PlanLocalDataSource localDataSource;
  PlanRepositoryImpl(this.localDataSource);

  @override
  Future<List<Plan>> getPlans() async {
    return await localDataSource.getPlans();
  }

  @override
  Future<Plan> addPlan({
    required String title,
    String? body,
    required dueAt,
  }) async {
    return await localDataSource.addPlan(
      title: title, 
      body: body,
      dueAt: dueAt
    );
  }

  @override
  Future<void> updatePlan({
    required int id,
    required String title,
    String? body,
    required dueAt
  }) {
    return localDataSource.updatePlan(
      id: id, 
      title: title, 
      body: body, 
      dueAt: dueAt
    );
  }

  @override
  Future<void> updatePlanStatus({
    required int id,
    required bool completed
  }) {
    return localDataSource.updatePlanStatus(
      id: id, 
      completed: completed
    );
  }

  @override
  Future<void> deletePlan(int id) {
    return localDataSource.deletePlan(id);
  }
}
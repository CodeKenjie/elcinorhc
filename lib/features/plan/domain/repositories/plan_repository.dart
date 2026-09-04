import '../entities/plan.dart';

abstract class PlanRepository {
  Future<List<Plan>> getPlans();

  Future<Plan> addPlan({
    required String title,
    required String? body,
    required DateTime dueAt,
  });

  Future<void> updatePlan({
    required int id,
    required String title,
    required String? body,
    required DateTime dueAt,
  });

  Future<void> updatePlanStatus({
    required int id,
    required bool completed
  });

  Future<void> deletePlan(int id);
}
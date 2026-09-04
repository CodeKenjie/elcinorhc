import 'package:drift/drift.dart';
import '../../../../core/database/local/local_database.dart';
import '../models/plan_model.dart';

class PlanLocalDataSource {
  final LocalDatabase localDatabase;

  PlanLocalDataSource(this.localDatabase);

  Future<List<PlanModel>> getPlans() async {
    final plans = await localDatabase.select(localDatabase.plans).get();
    return plans.map((plan) => PlanModel(
      id: plan.id,
      title: plan.title,
      body: plan.body,
      completed: plan.completed,
      createdAt: plan.createdAt,
      dueAt: plan.dueAt
    )).toList();
  }

  Future<PlanModel> addPlan({
    required String title,
    String? body,
    required DateTime dueAt
  }) async {
    final id = await localDatabase.into(localDatabase.plans).insert(
      PlansCompanion.insert(
        title: title, 
        body: Value(body),
        dueAt: dueAt
      )
    );

    final plan = await (localDatabase.select(localDatabase.plans)..where((plan) => plan.id.equals(id))).getSingle();

    return PlanModel(
      id: plan.id, 
      title: plan.title, 
      body: plan.body, 
      completed: plan.completed, 
      createdAt: plan.createdAt, 
      dueAt: plan.dueAt
    );
  }

  Future<int> updatePlan({
    required int id,
    required String title,
    required String? body,
    required DateTime dueAt
  }) {
    return (localDatabase.update(localDatabase.plans)..where((plan) => plan.id.equals(id))).write(
      PlansCompanion(
        title: Value(title),
        body: Value(body),
        dueAt: Value(dueAt)
      )
    );
  }

  Future<int> updatePlanStatus({
    required int id,
    required bool completed
  }) {
    return (localDatabase.update(localDatabase.plans)..where((plan) => plan.id.equals(id))).write(
      PlansCompanion(
        completed: Value(completed)
      )
    );
  }

  Future<int> deletePlan(int id) {
    return (localDatabase.delete(localDatabase.plans)..where((plan) => plan.id.equals(id))).go();
  }
}
import '../../domain/entities/plan.dart';

class PlanModel extends Plan {
  PlanModel({
    required super.id,
    required super.title,
    required super.body,
    required super.completed,
    required super.createdAt,
    required super.dueAt,
  });

  factory PlanModel.fromEntity(Plan plan) {
    return PlanModel(
      id: plan.id, 
      title: plan.title, 
      body: plan.body, 
      completed: plan.completed, 
      createdAt: plan.createdAt, 
      dueAt: plan.dueAt
    );
  }
}
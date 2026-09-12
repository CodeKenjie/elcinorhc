class PlannerProgress {
  final int totalTodo;
  final int completedTodos;
  final int remainingTodos;
  final double percentage;

  const PlannerProgress({
    required this.totalTodo,
    required this.completedTodos,
    required this.remainingTodos,
    required this.percentage
  });
}
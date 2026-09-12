import '../entities/user_progress.dart';
import '../entities/journal_progress.dart';
import '../entities/planner_progress.dart';
import '../../../journal/domain/repositories/journal_repository.dart';
import '../../../journal/domain/entities/journal.dart';
import '../../../todo/domain/repositories/todo_repository.dart';
import '../../../todo/domain/entities/todo.dart';

class GetUserProgress {
  final TodoRepository todoRepository;
  final JournalRepository journalRepository;

  const GetUserProgress({
    required this.todoRepository,
    required this.journalRepository
  });

  Future<UserProgress> execute() async {
    final todos = await todoRepository.getTodos();
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(const Duration(days: 29));
    final journalEntries = await journalRepository.getEntriesBetween(start: start, end: end.add(const Duration(days: 1)));
    final plannerProgress = _calculatePlannerProgree(todos);
    final journalProgress = _calculateJournalProgress(journalEntries, start, end);

    return UserProgress(
      planner: plannerProgress, 
      journal: journalProgress
    );
  }

  PlannerProgress _calculatePlannerProgree(List<Todo> todos) {
    final total = todos.length;

    if(total == 0) {
      return const PlannerProgress(
        totalTodo: 0, 
        completedTodos: 0, 
        remainingTodos: 0, 
        percentage: 0
      );
    }

    final completed = todos.where((todo) => todo.completed).length;

    return PlannerProgress(
      totalTodo: total, 
      completedTodos: completed, 
      remainingTodos: total - completed, 
      percentage: completed / total
    );
  }

  JournalProgress _calculateJournalProgress(List<Journal> journalEntries, DateTime start, DateTime end) {
    final journalDays = journalEntries.map((journal) {
      final date = journal.createdAt;
      return DateTime(date.year, date.month, date.day);
    }).toSet();

    final daysInPeriod = end.difference(start).inDays + 1;

    final frequency = daysInPeriod == 0 ? 0.0 : journalDays.length / daysInPeriod;

    final streak = _calculateStreak(journalDays);

    return JournalProgress(
      totalEntries: journalEntries.length, 
      daysJournaled: journalDays.length, 
      daysInPeriod: daysInPeriod, 
      frequency: frequency, 
      currentStreak: streak
    );
  }

  int _calculateStreak(Set<DateTime> journalDays) {
    if (journalDays.isEmpty) {
      return 0;
    }

    final now = DateTime.now();

    DateTime current = DateTime(now.year, now.month, now.day);

    if(!journalDays.contains(current)) {
      current = current.subtract(const Duration(days: 1));

      if(!journalDays.contains(current)) {
        return 0;
      }
    }

    int streak = 0;

    while(journalDays.contains(current)) {
      streak++;

      current = current.subtract(const Duration(days: 1));
    }

    return streak;
  }
}
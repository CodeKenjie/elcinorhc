import 'planner_progress.dart';
import 'journal_progress.dart';

class UserProgress {
  final PlannerProgress planner;
  final JournalProgress journal;

  const UserProgress({
    required this.planner,
    required this.journal
  });
}
class JournalProgress {
  final int totalEntries;
  final int daysJournaled;
  final int daysInPeriod;
  final double frequency;
  final int currentStreak;

  const JournalProgress({
    required this.totalEntries,
    required this.daysJournaled,
    required this.daysInPeriod,
    required this.frequency,
    required this.currentStreak
  });
}
import 'package:flutter/material.dart';
import '../../domain/entities/journal_progress.dart';

class StreakCard extends StatelessWidget {
  final JournalProgress progress;
  const StreakCard({ 
    super.key,
    required this.progress
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Text(
              '${progress.currentStreak}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Streak',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      )
    );
  }
}
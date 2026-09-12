import 'package:flutter/material.dart';
import '../../domain/entities/planner_progress.dart';

class TaskProgressCard extends StatelessWidget {
  final PlannerProgress progress;
  const TaskProgressCard({ 
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
              '${progress.completedTodos} / ${progress.totalTodo} tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress.percentage,
                minHeight: 20,
                backgroundColor: const Color.fromARGB(55, 67, 136, 111),
                color: const Color.fromARGB(255, 76, 175, 142),
              ),
            )
          ],
        ),
      )
    );
  }
}
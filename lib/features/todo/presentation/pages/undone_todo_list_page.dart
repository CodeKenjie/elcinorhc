import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_dialog.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_card.dart';

class UndoneTodoListPage extends StatefulWidget {
  const UndoneTodoListPage({super.key});

  @override
  State<UndoneTodoListPage> createState() => _UndoneTodoListPageState();
}

class _UndoneTodoListPageState extends State<UndoneTodoListPage> {
  final todoController = AppDependencies.todoController;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadTodos() async {
    await todoController.loadTodos();
  }

  bool _isToday(DateTime? date, DateTime startOfDay, DateTime endOfDay) {
    if(date == null) return false;
    return !date.isBefore(startOfDay) && date.isBefore(endOfDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: todoController,
        builder: (context, child) {
          if (todoController.isLoading && todoController.todos.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final now = DateTime.now();

          final startOfDay = DateTime(
            now.year,
            now.month,
            now.day,
          );

          final endOfDay = startOfDay.add(
            const Duration(days: 1),
          );

          final todaysTodos = todoController.todos.where((todo) {
            if (todo.completed) return false;
            if (todo.planId == null) return false;
            return _isToday(todo.startsAt, startOfDay, endOfDay) || _isToday(todo.endsAt, startOfDay, endOfDay) || _isToday(todo.expiresAt, startOfDay, endOfDay);
          }).toList();

          final unplannedTodos = todoController.todos.where((todo) {
            if (todo.completed) return false;
            if (todo.planId != null) return false;
            return true;
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Todays Tasks',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: ListView(
                    children: [
                      if (todaysTodos.isEmpty)
                        _buildEmptyState(
                          'No available task',
                        )
                      else
                        ...todaysTodos.map(
                          (todo) => TodoCard(
                            todo: todo,
                            onChanged: (value) {
                              todoController.updateStatus(
                                id: todo.id,
                                completed: value,
                              );
                            },
                            onEdit: (context) {
                              showDialog(
                                context: context,
                                builder: (context) => TodoDialog(
                                  todo: todo,
                                  controller: todoController,
                                ),
                              );
                            },
                            onDelete: (context) {
                              todoController.delete(todo.id);
                            },
                          ),
                        ),

                      const SizedBox(height: 16),

                      Text(
                        'Unplanned Tasks',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (unplannedTodos.isEmpty)
                        _buildEmptyState(
                          'No unplanned task',
                        )
                      else
                        ...unplannedTodos.map(
                          (todo) => TodoCard(
                            todo: todo,
                            onChanged: (value) {
                              todoController.updateStatus(
                                id: todo.id,
                                completed: value,
                              );
                            },
                            onEdit: (context) {
                              showDialog(
                                context: context,
                                builder: (context) => TodoDialog(
                                  todo: todo,
                                  controller: todoController,
                                ),
                              );
                            },
                            onDelete: (context) {
                              todoController.delete(todo.id);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 76, 175, 142),
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => TodoDialog(
              controller: todoController,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.secondary
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.tertiary
        ),
      ),
    );
  }
}

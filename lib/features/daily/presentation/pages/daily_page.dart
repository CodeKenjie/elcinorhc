import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_dialog.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_card.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  final todoController = AppDependencies.todoController;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    await todoController.loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            if (todo.expiresAt == null) return false;
            if (todo.planId == null) return false;

            return !todo.expiresAt!.isBefore(startOfDay) &&
                todo.expiresAt!.isBefore(endOfDay);
          }).toList();

          final unplannedTodos = todoController.todos.where((todo) {
            return !todo.completed && todo.planId == null;
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Todays Tasks',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
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

                      const Text(
                        'Unplanned Tasks',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
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
        elevation: 0,
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
        borderRadius: BorderRadius.circular(5),
        border: const Border(
          bottom: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

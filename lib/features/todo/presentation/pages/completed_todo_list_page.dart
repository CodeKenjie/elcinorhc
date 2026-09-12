import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_dialog.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_card.dart';

class CompletedTodoListPage extends StatefulWidget {
  const CompletedTodoListPage({super.key});

  @override
  State<CompletedTodoListPage> createState() => _CompletedTodoListPageState();
}

class _CompletedTodoListPageState extends State<CompletedTodoListPage> {
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
      appBar: AppBar(
        title: Row (
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.task_alt),
            const SizedBox(width: 8),
            Text(
              'Completed task',
              style: TextStyle(
                fontSize: 20
              )
            )
          ],
        )
      ),
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

          final completedTodos = todoController.todos.where((todo) => todo.completed).toList();
          final undoneExpiredTodos = todoController.todos.where((todo) => !todo.completed && todo.expiresAt != null && todo.expiresAt!.isBefore(startOfDay)).toList();

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completed Tasks',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: ListView(
                    children: [
                      if (completedTodos.isEmpty)
                        _buildEmptyState(
                          'No available task',
                        )
                      else
                        ...completedTodos.map(
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

                      Text(
                        'Forgotten Tasks',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),

                      const SizedBox(height: 8),
                      if (undoneExpiredTodos.isEmpty)
                        _buildEmptyState(
                          'No unplanned task',
                        )
                      else
                        ...undoneExpiredTodos.map(
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
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
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

import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_dialog.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_card.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({ super.key });

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Tasks'
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: todoController, 
              builder: (context, child) {
                final todos = todoController.todos;
                if(todos.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border(bottom: BorderSide(color: Colors.black))
                    ),
                    child: Text(
                      'No task for today', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: 
                        FontWeight.bold, 
                        color: Colors.grey
                      )
                    )
                  );
                }

                return Expanded (
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoCard(
                        title: todo.title, 
                        state: todo.completed, 
                        createdAt: todo.createdAt, 
                        expiresAt: todo.expiresAt,
                        onChanged: (value) {
                          todoController.updateStatus(
                            id: todo.id, 
                            completed: value ?? false
                          );
                        },
                        onEdit: (context) {
                          showDialog(
                            context: context, 
                            builder: (context) => TodoDialog(controller: AppDependencies.todoController, todo: todo)
                          );
                        },
                        onDelete: (context) {
                          todoController.delete(todo.id);
                        },
                      );
                    },
                  )
                );
              }
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) => TodoDialog(controller: todoController)
          );
        }
      ),
    );
  }
}
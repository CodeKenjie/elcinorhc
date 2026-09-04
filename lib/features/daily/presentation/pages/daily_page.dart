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
              'ToDo Tasks:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: todoController, 
              builder: (context, child) {
                final todos = todoController.todos.where((todo) => !todo.completed && (todo.expiresAt == null || todo.expiresAt!.isAfter(DateTime.now()))).toList();

                if(todoController.isLoading && todoController.todos.isEmpty){
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator()
                    ),
                  );
                }

                if(todos.isEmpty) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border(bottom: BorderSide(color: Colors.black))
                    ),
                    child: Column (
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No available task', 
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: 
                            FontWeight.bold, 
                            color: Colors.grey
                          )
                        )
                      ]
                    )
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return TodoCard(
                        todo: todo,
                        onChanged: (value) => todoController.updateStatus(
                          id: todo.id, 
                          completed: value
                        ),
                        onEdit: (context) {
                          showDialog(
                            context: context, 
                            builder: (context) => TodoDialog(
                              todo: todo,
                              controller: todoController
                            )
                          );
                        },
                        onDelete: (context) {
                          todoController.delete(todo.id);
                        },
                      );
                    }
                  )
                );
              }
            ),
            const SizedBox(height: 16),
            Text(
              'Completed Tasks:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: todoController, 
              builder: (context, child) {
                final todos = todoController.todos.where((todo) => todo.completed).toList();

                if(todoController.isLoading && todoController.todos.isEmpty){
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator()
                    ),
                  );
                }

                if(todos.isEmpty) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border(bottom: BorderSide(color: Colors.black))
                    ),
                    child: Column (
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No completed task', 
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: 
                            FontWeight.bold, 
                            color: Colors.grey
                          )
                        )
                      ]
                    )
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todos = todoController.todos.where((todo) => todo.completed).toList();
                      final todo = todos[index];
                      return TodoCard(
                        todo: todo,
                        onChanged: (value) => todoController.updateStatus(
                          id: todo.id, 
                          completed: value
                        ),
                        onEdit: (context) {
                          showDialog(
                            context: context, 
                            builder: (context) => TodoDialog(
                              todo: todo,
                              controller: todoController
                            )
                          );
                        },
                        onDelete: (context) {
                          todoController.delete(todo.id);
                        },
                      );
                    }
                  )
                );
              }
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
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
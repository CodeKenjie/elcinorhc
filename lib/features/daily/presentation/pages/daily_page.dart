import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_dialog.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({ super.key });

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  final todoController = AppDependencies.todoController;
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
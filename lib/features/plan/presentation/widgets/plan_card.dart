import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:elcinorch/features/plan/domain/entities/plan.dart';
import 'package:elcinorch/features/todo/presentation/controllers/todo_controller.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_dialog.dart';
import 'package:elcinorch/features/todo/domain/entities/todo.dart';

class PlanCard extends StatelessWidget {
  final Plan plan;
  final TodoController todoController;
  final ValueChanged<bool>? onChanged;
  final Function(BuildContext)? onEdit;
  final Function()? addTodo;
  final Function(BuildContext)? onDelete;

  const PlanCard({
    super.key, 
    required this.plan, 
    required this.todoController,
    this.onChanged,
    this.onEdit,
    this.onDelete,
    this.addTodo
  });

  String _formattedDate(DateTime? date){
    if (date == null) return '';
    return DateFormat('MMM dd, yyyy EEE').format(date).toString();
  }

  double calculateProgress(List<Todo> todos){
    if(todos.isEmpty) return 0.0;

    final completed = todos.where((todo) => todo.completed).length;

    return completed / todos.length;
  }

  String _formattedTime(DateTime? date){
    if (date == null) return '';
    return DateFormat('h:mm a').format(date).toString();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return ListenableBuilder(
      listenable: todoController, 
      builder: (context, child) {
        final todos = todoController.todos.where((todo){
          if(todo.planId == null) return false;
          return todo.planId == plan.id;
        }).toList();

        return Slidable(
          startActionPane: plan.completed ? null : ActionPane(
            motion: ScrollMotion(), 
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: onEdit,
                icon: Icons.edit,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(20),
              ),
            ]
          ),
          endActionPane: ActionPane(
            motion: ScrollMotion(), 
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: onDelete,
                icon: Icons.delete_rounded,
                backgroundColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(20),
              ),
            ]
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          plan.dueAt.isBefore(today) ? 'Expired plan' : _formattedDate(plan.dueAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary
                          ),
                        ),
                      ],
                    ),
                    Checkbox(
                      value: plan.completed, 
                      visualDensity: VisualDensity.compact,
                      activeColor: const Color.fromARGB(255, 76, 175, 142),
                      shape: const CircleBorder(),
                      side: BorderSide(
                        color: const Color.fromARGB(255, 76, 175, 142)
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: onChanged == null ? null : (value) {
                        if(value != null) {
                          onChanged!(value);
                        }
                      }
                    )
                  ],
                ),
                if(plan.body != '')... [
                  const SizedBox(height: 5),
                  Text(
                    plan.body ?? '',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: todos.map((todo) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            icon: Icons.edit,
                            onPressed: (context){
                              showDialog(
                                context: context, 
                                builder: (context) => TodoDialog(
                                  todo: todo, 
                                  controller: todoController, 
                                  expiresAt: todo.expiresAt
                                )
                              );
                            }
                          ),
                          SlidableAction(
                            icon: Icons.remove_circle_outline_outlined,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            onPressed: (context){
                              todoController.delete(todo.id);
                            }
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              activeColor: const Color.fromARGB(255, 76, 175, 142),
                              value: todo.completed, 
                              shape: const CircleBorder(),
                              side: BorderSide(
                                color:const Color.fromARGB(255, 76, 175, 142)
                              ),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onChanged: (value){
                                todoController.updateStatus(id: todo.id, completed: value!);
                              }
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    todo.title,
                                    style: TextStyle(
                                      fontSize: 14
                                    ),
                                  ),
                                  Text(
                                    '${_formattedTime(todo.startsAt)} - ${_formattedTime(todo.endsAt)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.tertiary
                                    ),
                                  )
                                ],
                              ) 
                            ),
                            if(todo.expiresAt!.isBefore(today))... [
                              Text(
                                'Expired Task',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.tertiary
                                ),
                              ),
                            ]
                          ],
                        )
                      )
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                if(!plan.dueAt.isBefore(today))... [
                  GestureDetector(
                    onTap: addTodo,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 76, 175, 142),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_task, size: 14, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            'Add task',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                            ),
                          )
                        ],
                      ),
                    )
                  )
                ],
                if(todos.isNotEmpty)... [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(20),
                          child: LinearProgressIndicator(
                            value: calculateProgress(todos),
                            backgroundColor: const Color.fromARGB(55, 67, 136, 111),
                            minHeight: 6,
                            color: const Color.fromARGB(255, 76, 175, 142),
                          )
                        )
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(calculateProgress(todos) * 100).round()}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 76, 175, 142),
                        ),
                      )
                    ],
                  )
                ]
              ]
            ),
          )
        );
      }
    );
  }
}
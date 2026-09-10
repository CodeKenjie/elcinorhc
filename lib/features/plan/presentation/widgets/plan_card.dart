import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:elcinorch/features/plan/domain/entities/plan.dart';
import 'package:elcinorch/features/todo/presentation/controllers/todo_controller.dart';
import 'package:elcinorch/features/todo/presentation/widgets/todo_dialog.dart';

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
    if (date == null) {
      return '';
    }
    return DateFormat('MMM dd, yyyy EEE').format(date).toString();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

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
          borderRadius: BorderRadius.circular(5)
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
            AnimatedBuilder(
              animation: todoController, 
              builder: (context, child) {
                final planTodos = todoController.todos.where((todo) {
                  if(todo.planId == null) return false;
                  return todo.planId == plan.id;
                }).toList();

                if (planTodos.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: planTodos.map((todo) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
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
                            onPressed: (context){
                              todoController.delete(todo.id);
                            }
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: todo.completed, 
                              shape: const CircleBorder(),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onChanged: (value){
                                todoController.updateStatus(id: todo.id, completed: value!);
                              }
                            ),
                            Expanded(
                              child: Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 14
                                ),
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
                );
              }
            ),
            const SizedBox(height: 8),
            if(!plan.dueAt.isBefore(today))... [
              GestureDetector(
                onTap: addTodo,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_task, size: 14, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Add task',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary
                        ),
                      )
                    ],
                  ),
                )
              )
            ]
          ]
        ),
      )
    );
  }
}
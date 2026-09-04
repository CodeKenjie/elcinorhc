import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:elcinorch/features/todo/domain/entities/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo; 
  final ValueChanged<bool>? onChanged;
  final Function(BuildContext)? onEdit;
  final Function(BuildContext)? onDelete;

  const TodoCard({ 
    super.key,
    required this.todo,
    this.onChanged,
    this.onEdit,
    this.onDelete
  });

  String formatDate(DateTime? date) {
    if(date == null) {
      return '';
    }
    return DateFormat('MMM dd, yyyy EEE').format(date).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Slidable(
        startActionPane: todo.completed ? null : ActionPane(
          motion: ScrollMotion(), 
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: onEdit,
              icon: Icons.edit,
              backgroundColor: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
          ]
        ),
        endActionPane: ActionPane(
          motion: ScrollMotion(), 
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: onDelete,
              icon: Icons.delete,
              backgroundColor: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          ]
        ),
        child: Container(
          padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(5),
            border: Border(
              bottom: BorderSide(color: Colors.black)
            )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: todo.completed, 
                onChanged: onChanged == null ? null : (value) => {
                  if(value != null) {
                    onChanged!(value)
                  }
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text ( 
                      todo.title, 
                      style: TextStyle(fontSize: 16) 
                    ),
                    const SizedBox(height: 2),
                    Text ( 
                      formatDate(todo.createdAt), 
                      style: TextStyle(
                        fontSize: 12, 
                        color: Colors.grey
                      ) 
                    ),
                  ],
                )
              ),
              const SizedBox(width: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(todo.expiresAt != null)...[
                    Text (
                      'Due date:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey
                      ),
                    )
                  ],
                  Text(
                    formatDate(todo.expiresAt), 
                    style: TextStyle(
                      fontSize: 14, 
                      color: Colors.grey
                    ) 
                  ),
                ],
              )
            ],
          ),
        ),
      )
      
    );
  }
}
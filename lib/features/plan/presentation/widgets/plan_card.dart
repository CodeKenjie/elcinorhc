import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:elcinorch/features/plan/domain/entities/plan.dart';

class PlanCard extends StatelessWidget {
  final Plan plan;
  final ValueChanged<bool>? onChanged;
  final Function(BuildContext)? onEdit;
  final Function(BuildContext)? addTodo;
  final Function(BuildContext)? onDelete;

  const PlanCard({
    super.key, 
    required this.plan, 
    this.onChanged,
    this.onEdit,
    this.onDelete,
    this.addTodo
  });

  String _formattedDate(DateTime date){
    return DateFormat('MMM dd, yyyy EEE').format(date).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: plan.completed ? null : ActionPane(
        motion: ScrollMotion(), 
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: addTodo,
            icon: Icons.add_task,
            backgroundColor: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          SlidableAction(
            onPressed: onEdit,
            icon: Icons.edit,
            backgroundColor: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10),
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
        decoration: BoxDecoration(
          color: Colors.white,
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
                      _formattedDate(plan.dueAt),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
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
              const SizedBox(height: 10),
              Text(
                plan.body ?? '',
                style: TextStyle(
                  fontSize: 18,
                ),
              )
            ]
          ],
        ),
      )
    );
  }
}
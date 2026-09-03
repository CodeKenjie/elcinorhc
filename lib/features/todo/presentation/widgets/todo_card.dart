import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoCard extends StatelessWidget {
  final String title;
  final bool state;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final ValueChanged<bool?>? onChanged;
  final Function(BuildContext)? onEdit;
  final Function(BuildContext)? onDelete;

  const TodoCard({ 
    super.key,
    required this.title,
    required this.state,
    required this.createdAt,
    this.expiresAt,
    this.onChanged,
    this.onEdit,
    this.onDelete
  });

  String formatDate(DateTime? date) {
    if(date == null) {
      return '';
    }
    return DateFormat('MM dd, yyyy EEE').format(date).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Slidable(
        startActionPane: ActionPane(
          motion: ScrollMotion(), 
          extentRatio: 0.25,
          children: [
            if(state == false)...[
              SlidableAction(
                onPressed: onEdit,
                icon: Icons.edit,
                backgroundColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
            ]
          ]
        ),
        endActionPane: ActionPane(
          motion: ScrollMotion(), 
          extentRatio: 0.25,
          children: [
            if(state == false)...[
              SlidableAction(
                onPressed: onDelete,
                icon: Icons.delete,
                backgroundColor: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
            ]
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
                value: state, 
                onChanged: onChanged,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text ( 
                      title, 
                      style: TextStyle(fontSize: 16) 
                    ),
                    const SizedBox(height: 2),
                    Text ( 
                      formatDate(createdAt), 
                      style: TextStyle(
                        fontSize: 12, 
                        color: Colors.grey
                      ) 
                    ),
                  ],
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(expiresAt != null)...[
                    Text (
                      'Expr date:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey
                      ),
                    )
                  ],
                  Text(
                    formatDate(expiresAt), 
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
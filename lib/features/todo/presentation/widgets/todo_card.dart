import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:elcinorch/features/todo/domain/entities/todo.dart';
import 'dart:async';

class TodoCard extends StatefulWidget {
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

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  Timer? _progressTimer;

  @override
  void initState(){
    super.initState();
    _progressTimer = Timer.periodic(const Duration(seconds: 30), (_){
      if(mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  String formatDate(DateTime? date) {
    if(date == null) {
      return '';
    }
    return DateFormat('MMM dd, yyyy EEE').format(date).toString();
  }

  String formatTime(DateTime? dateTime){
    if(dateTime == null) return '';
    return DateFormat('h:mm a').format(dateTime).toString();
  }

  String formatDateTime(DateTime? dateTime){
    if(dateTime == null) return '';
    return DateFormat('MMM dd, yyyy • h:mm a').format(dateTime).toString();
  }

  double _getTaskProgress() {
    if(widget.todo.startsAt == null || widget.todo.endsAt == null) {
      return 0.0;
    }

    final now = DateTime.now();
    final start = widget.todo.startsAt!;
    final end = widget.todo.endsAt!;

    if(now.isBefore(start)) return 0.0;

    if(now.isAfter(end)) return 1.0;

    final totalDuration = end.difference(start).inMicroseconds;
    final elapsedDuration = now.difference(start).inMicroseconds;

    if (totalDuration <= 0) return 0.0;

    return (elapsedDuration / totalDuration).clamp(0.0, 1.0);
  }

  bool _isEndDue() {
    if(widget.todo.completed) return false;
    if(widget.todo.expiresAt == null) return false;
    if(widget.todo.startsAt == null || widget.todo.endsAt == null) return false;
    return widget.todo.endsAt!.isBefore(DateTime.now());
  }

  bool _isOverDue() {
    if(widget.todo.completed) return false;
    if(widget.todo.expiresAt == null) return false;
    if(widget.todo.startsAt == null || widget.todo.endsAt == null) return false;
    return widget.todo.expiresAt!.isBefore(DateTime.now()) && widget.todo.endsAt!.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Slidable(
        startActionPane: widget.todo.completed ? null : ActionPane(
          motion: ScrollMotion(), 
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: widget.onEdit,
              icon: Icons.edit,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(10),
            ),
          ]
        ),
        endActionPane: ActionPane(
          motion: ScrollMotion(), 
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: widget.onDelete,
              icon: Icons.delete,
              backgroundColor: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          ]
        ),
        child: Container(
          padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: widget.todo.completed, 
                    activeColor: const Color.fromARGB(255, 76, 175, 142),
                    shape: const CircleBorder(),
                    side: BorderSide(
                      color: const Color.fromARGB(255, 76, 175, 142)
                    ),
                    onChanged: widget.onChanged == null ? null : (value) => {
                      if(value != null) {
                        widget.onChanged!(value)
                      }
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text ( 
                          widget.todo.title, 
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 20
                          ) 
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text ( 
                              'created: ${formatDate(widget.todo.createdAt)}',
                              style: TextStyle(
                                fontSize: 12, 
                                color: Theme.of(context).colorScheme.tertiary
                              ) 
                            ),
                            if(widget.todo.expiresAt != null) ... [
                              Text ( 
                                'expr: ${formatDate(widget.todo.expiresAt)}',
                                style: TextStyle(
                                  fontSize: 12, 
                                  color: Theme.of(context).colorScheme.tertiary
                                ) 
                              ),
                            ]
                          ],
                        )
                      ],
                    )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(widget.todo.completedAt == null) ... [
                      if(widget.todo.startsAt != null && widget.todo.endsAt != null) ... [
                        Text (
                          formatTime(widget.todo.startsAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: _getTaskProgress(),
                              minHeight: 6,
                              backgroundColor: const Color.fromARGB(55, 67, 136, 111),
                              color:_isOverDue() ? Colors.redAccent : _isEndDue() ? Colors.yellowAccent : const Color.fromARGB(255, 76, 175, 142),
                            )
                          )
                        ),
                        const SizedBox(width: 5),
                        Text (
                          formatTime(widget.todo.endsAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary
                          ),
                        ),
                      ],
                    ] else ... [
                      Text (
                        'Completed at:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),
                      Text (
                        formatDateTime(widget.todo.completedAt),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
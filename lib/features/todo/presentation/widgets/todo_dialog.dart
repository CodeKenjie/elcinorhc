import 'package:flutter/material.dart';
import 'package:elcinorch/features/todo/presentation/controllers/todo_controller.dart';
import 'package:elcinorch/features/todo/domain/entities/todo.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class TodoDialog extends StatefulWidget {
  final int? planId;
  final Todo? todo;
  final DateTime? expiresAt;
  final TodoController controller;
  const TodoDialog({ 
    super.key, 
    required this.controller, 
    this.todo, 
    this.planId, 
    this.expiresAt 
  });
  bool get isEditing => todo != null;

  @override
  State<TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  final _titleController = TextEditingController();
  DateTime? _expiresAt;
  DateTime? _startsAt;
  DateTime? _endsAt;

  @override
  void initState(){
    super.initState();
    if(widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _expiresAt = widget.todo!.expiresAt;
      _startsAt = widget.todo!.startsAt;
      _endsAt = widget.todo!.endsAt;
    } else if(widget.expiresAt != null) {
      _expiresAt = widget.expiresAt;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDateTime({
    DateTime? initialDateTime,
    required DateTime expiresAt,
  }) async {
    final now = DateTime.now();
    final initial = initialDateTime ?? now;

    final pickedTime = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.fromDateTime(initial)
    );

    if (pickedTime == null) return null;

    return DateTime(
      expiresAt.year,
      expiresAt.month,
      expiresAt.day,
      pickedTime.hour,
      pickedTime.minute
    );
  }

  Future<void> _submit() async {
    if(widget.controller.isLoading) return;

    final String title = _titleController.text.trim();
    final DateTime? startsAt = _startsAt;
    final DateTime? endsAt = _endsAt;
    final DateTime? expirationDate = _expiresAt;
    bool success;

    if(title.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a task title')));
      return;
    }

    if(startsAt != null && endsAt != null && !endsAt.isAfter(startsAt)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ends at time must be after start time')));
      return;
    }

    if(widget.isEditing) {
      success = await widget.controller.update(
        id: widget.todo!.id, 
        planId: widget.todo!.planId,
        title: title,
        startsAt: startsAt,
        endsAt: endsAt,
        expiresAt: expirationDate
      );

      if(!mounted) return;

      if(!success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.controller.errorMessage ?? 'Something went wrong!.')));
        return;
      }

      Navigator.pop(context);
    } else {
      success = await widget.controller.create(
        planId: widget.planId,
        title: title,
        startsAt: startsAt,
        endsAt: endsAt,
        expiresAt: expirationDate
      );

      if(!mounted) return;

      if(!success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.controller.errorMessage ?? 'Something went wrong!.')));
        return;
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context){
    return AnimatedBuilder(
      animation: widget.controller, 
      builder: (context, child) {
        final screenSize = MediaQuery.of(context).size;
        return AlertDialog(
          title: Text(widget.isEditing ? 'Edit Task' : 'Create Task'),
          content: SizedBox(
            width: math.min(screenSize.width * 0.9, 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Task name',
                    border: OutlineInputBorder(),
                    labelText: 'Task name'
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary)
                  ),
                  leading: const Icon(Icons.calendar_today),
                  title: Text( _expiresAt == null ? 'Expiration Date' : DateFormat('MMM d, y').format(_expiresAt!)),
                  onTap: () async {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final initial = _expiresAt ?? DateTime.now();
                    final pickedDate = await showDatePicker(
                      context: context, 
                      initialDate: initial,
                      firstDate: initial.isBefore(today) ? initial : today, 
                      lastDate: DateTime(3064)
                    );

                    if(!mounted) return;
                    if (pickedDate != null) {
                      setState(() {
                        _expiresAt = pickedDate;
                      });
                    }
                  },
                  trailing: _expiresAt != null ? TextButton(
                    child: const Text('clear', style: TextStyle(color: Colors.redAccent),),
                    onPressed: () {
                      setState(() {
                        _expiresAt = null;
                      });
                    }, 
                  ) : null,
                ),

                const SizedBox(height: 16),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary)
                  ),
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    _startsAt == null 
                    ? 'Start time' 
                    : DateFormat('MMM d, y • h:mm a').format(_startsAt!)
                  ),
                  onTap: () async {
                    final pickedStart = await _pickDateTime(
                      initialDateTime: _startsAt,
                      expiresAt: _expiresAt ?? DateTime.now()
                    );
                     
                    if(!mounted) return;
                    if (pickedStart != null) {
                      setState(() {
                        _startsAt = pickedStart;
                      });
                    }
                  },
                  trailing: _startsAt != null ? TextButton(
                    child: const Text('clear', style: TextStyle(color: Colors.redAccent),),
                    onPressed: () {
                      setState(() {
                        _startsAt = null;
                      });
                    }, 
                  ) : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary)
                  ),
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    _endsAt == null 
                    ? 'End time' 
                    : DateFormat('MMM d, y • h:mm a').format(_endsAt!)
                  ),
                  onTap: () async {
                    final pickedEnd = await _pickDateTime(
                      initialDateTime: _endsAt ?? _startsAt,
                      expiresAt: _expiresAt ?? DateTime.now()
                    );
                     
                    if(!mounted) return;
                    if (pickedEnd != null) {
                      setState(() {
                        _endsAt = pickedEnd;
                      });
                    }
                  },
                  trailing: _endsAt != null ? TextButton(
                    child: const Text('clear', style: TextStyle(color: Colors.redAccent),),
                    onPressed: () {
                      setState(() {
                        _endsAt = null;
                      });
                    }, 
                  ) : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: widget.controller.isLoading ? null : () { Navigator.pop(context); }, 
              child: const Text('Cancel')
            ),
            TextButton(
              onPressed: widget.controller.isLoading ? null : _submit, 
              child: widget.controller.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : Text(widget.isEditing ? 'Save' : 'Add')
            )
          ]
        );
      },
    );
  }
}
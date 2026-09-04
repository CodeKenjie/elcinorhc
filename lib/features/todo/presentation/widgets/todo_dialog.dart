import 'package:flutter/material.dart';
import 'package:elcinorch/features/todo/presentation/controllers/todo_controller.dart';
import 'package:elcinorch/features/todo/domain/entities/todo.dart';

class TodoDialog extends StatefulWidget {
  final int? planId;
  final Todo? todo;
  final DateTime? expiresAt;
  final TodoController controller;
  const TodoDialog({ super.key, required this.controller, this.todo, this.planId, this.expiresAt });
  bool get isEditing => todo != null;

  @override
  State<TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  final _titleController = TextEditingController();
  DateTime? _expiresAt;

  @override
  void initState(){
    super.initState();
    if(widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _expiresAt = widget.todo!.expiresAt;
    } else if(widget.expiresAt != null) {
      _expiresAt = widget.expiresAt;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String title = _titleController.text.trim();
    final DateTime? expirationDate = _expiresAt;
    bool success;

    if(title.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a task title')));
      return;
    }

    if(widget.isEditing) {
      success = await widget.controller.update(
        id: widget.todo!.id, 
        planId: widget.todo!.planId,
        title: title,
        expiresAt: expirationDate
      );

      if(!mounted) return;

      Navigator.pop(context);
    } else {
      success = await widget.controller.create(
        planId: widget.planId,
        title: title,
        expiresAt: expirationDate
      );

      if(success) {
        if(!mounted) return;

        Navigator.pop(context);
      } else {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.controller.errorMessage ?? 'Something went wrong!.')));
        return;
      }
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
            width: screenSize.width,
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
                    side: const BorderSide(color: Colors.grey)
                  ),
                  leading: const Icon(Icons.calendar_today),
                  title: Text( _expiresAt == null ? 'Expiration Date' : '${_expiresAt!.month}/${_expiresAt!.day}/${_expiresAt!.year}'),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context, 
                      initialDate: _expiresAt ?? DateTime.now(),
                      firstDate: DateTime.now(), 
                      lastDate: DateTime(3064)
                    );

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
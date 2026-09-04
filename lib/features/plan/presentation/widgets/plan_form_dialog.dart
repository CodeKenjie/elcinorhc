import 'package:flutter/material.dart';
import '../../domain/entities/plan.dart';
import '../controller/plan_controller.dart';

class PlanFormDialog extends StatefulWidget {
  final Plan? plan;
  final PlanController controller;
  final DateTime dueAt;

  const PlanFormDialog({
    super.key,
    required this.controller,
    required this.dueAt,
    this.plan
  });

  bool get isEditing => plan != null;

  @override
  State<PlanFormDialog> createState() => _PlanFormDialogState();
}

class _PlanFormDialogState extends State<PlanFormDialog> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if(widget.plan != null) {
      _titleController.text = widget.plan!.title;
      _bodyController.text = widget.plan!.body ?? "";
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String title = _titleController.text.trim();
    final String body = _bodyController.text.trim();
    final DateTime dueAt = _selectedDate ?? widget.dueAt;
    bool success;

    if(title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a task title')));
      return;
    }

    if (widget.isEditing) {
      success = await widget.controller.update(
        id: widget.plan!.id, 
        title: title, 
        body: body,
        dueAt: dueAt
      );

      if(!mounted) return;
      Navigator.pop(context);
    } else {
      success = await widget.controller.create(
        title: title, 
        body: body,
        dueAt: dueAt
      );

      if(success) {
        if(!mounted) return;
        Navigator.pop(context);
      } else {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.controller.errorMessage ?? 'Something went wrong.')));
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller, 
      builder: (context, child) {
        return AlertDialog(
          title: Text( widget.isEditing ? 'Edit Plan' : 'Create Plan' ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                    labelText: 'Title'
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 5,
                  controller: _bodyController,
                  decoration: InputDecoration(
                    hintText: 'Details',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Due date',
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
                const SizedBox(height: 3),
                ListTile(
                  contentPadding: const EdgeInsets.only(left: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Colors.grey)
                  ),
                  leading: const Icon(Icons.calendar_today),
                  title: Text('${widget.dueAt.month}/${widget.dueAt.day}/${widget.dueAt.year}'),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.dueAt,
                      firstDate: DateTime.now(), 
                      lastDate: DateTime(3064)
                    );

                    if(pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                )
              ],
            )
          ),
          actions: [
            TextButton(
              onPressed: widget.controller.isLoading ? null : () {
                Navigator.pop(context);
              },
              child: Text('Cancel')
            ),
            TextButton(
              onPressed: _submit,
              child: widget.controller.isLoading ? const SizedBox( width: 20, height: 20, child: CircularProgressIndicator()) : Text(widget.isEditing ? 'Save' : 'Create')
            ),
          ],
        );
      }
    ) 
    ;
  }
}
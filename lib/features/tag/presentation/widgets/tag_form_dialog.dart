import 'package:flutter/material.dart';
import '../controllers/tag_controller.dart';

class TagFormDialog extends StatefulWidget {
  final TagController controller;

  const TagFormDialog({
    super.key,
    required this.controller
  });

  @override
  State<TagFormDialog> createState() => _TagFormDialogState();
}

class _TagFormDialogState extends State<TagFormDialog> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if(widget.controller.isLoading) return;

    final name = _nameController.text;
    bool success;

    if(name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name field can\'t be blank')
        )
      );
      return;
    }

    success = await widget.controller.create(name: name);

    if(!mounted) return;

    if(!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage ?? "Something went wrong!")
        )
      );
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return AlertDialog(
          title: Text('Create Tag'),
          content: SingleChildScrollView(
            child:SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    maxLines: 1,
                    maxLength: 50,
                    decoration: InputDecoration(
                      hintText: 'Tag Label',
                      labelText: 'Tag Label',
                      border: OutlineInputBorder()
                    ),
                  )
                ],
              )
            )
          ),
          actions: [
            TextButton(
              onPressed:() {
                Navigator.pop(context);
              },
              child: Text('Cancel')
            ),
            TextButton(
              onPressed: _submit,
              child: widget.controller.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : Text('Create'),
            )
          ]
        );
      }
    );
  }
}
import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';
import '../controllers/journal_tag_controller.dart';

class JournalTagFormDialog extends StatefulWidget {
  final int journalId;
  final JournalTagController controller;
  const JournalTagFormDialog({
    super.key,
    required this.journalId,
    required this.controller
  });

  @override
  State<JournalTagFormDialog> createState() => _JournalTagFormDialogState();
}

class _JournalTagFormDialogState extends State<JournalTagFormDialog> {
  int? selectedTag;
  final tagController = AppDependencies.tagController;

  @override
  void initState() {
    super.initState();

    _loadTags();
  }

  void _loadTags() async {
    await tagController.getTags();
    if(!mounted) return;
    setState(() {});
  }

  void _submit() async {
    if(tagController.isLoading) return;

    final journalId = widget.journalId;
    final tagId = selectedTag;
    bool success;

    if(tagId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to select a tag.'))
      );
      return;
    }

    success = await widget.controller.create(tagId: tagId, journalId: journalId);

    if(!mounted) return;
    if(!success) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.controller.errorMessage ?? 'Something went wrong!'))
      );
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Tag'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListenableBuilder(
                listenable: tagController,
                builder: (context, child) {
                  return DropdownButtonFormField<int>(
                    initialValue: selectedTag,
                    decoration: InputDecoration(
                      labelText: 'Tag',
                      border: OutlineInputBorder(),
                    ),
                    items: tagController.tags.map((tag) {
                      return DropdownMenuItem<int>(
                        value: tag.id,
                        child: Text(tag.name)
                      );
                    }).toList(), 
                    onChanged: (value) {
                      setState(() {
                        selectedTag = value;
                      });
                    }
                  );
                }
              ),
            ],
          )
        )
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          child: Text('Cancel')
        ),
        TextButton(
          onPressed: _submit,
          child: widget.controller.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : Text('Add')
        )
      ],
    );
  }
}
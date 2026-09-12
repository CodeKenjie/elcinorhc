import 'package:flutter/material.dart';
import '../../domain/entities/journal.dart';
import '../../presentation/controllers/journal_controller.dart';

class JournalFormPage extends StatefulWidget {
  final Journal? journal;
  final JournalController controller;
  const JournalFormPage({
    super.key,
    required this.controller,
    this.journal
  });

  bool get isEditing => journal != null;

  @override
  State<JournalFormPage> createState() => _JournalFormPageState();
}

class _JournalFormPageState extends State<JournalFormPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.isEditing){
      _titleController.text = widget.journal!.title;
      _bodyController.text = widget.journal!.body;
    }
  }

  @override
  void dispose(){
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() async {
    if(widget.controller.isLoading) return;

    final title = _titleController.text;
    final body = _bodyController.text;
    bool success;

    if(title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'We can\'t create a journal without a title.'
          )
        )
      );
      return;
    }

    if(body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'We can\'t create a journal without a body.'
          )
        )
      );
      return;
    }

    if(widget.isEditing){
      success = await widget.controller.edit(
        id: widget.journal!.id, 
        title: title, 
        body: body
      );

      if(!mounted) return;

      if(!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.controller.errorMessage ?? 'Something went wrong'
            )
          )
        );
      }

      Navigator.pop(context);
    } else {
      success = await widget.controller.create(
        title: title, 
        body: body
      );

      if(!mounted) return;

      if(!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.controller.errorMessage ?? 'Something went wrong'
            )
          )
        );
        return;
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon ( Icons.book ),
            const SizedBox(width: 10),
            Text(
              widget.isEditing ? widget.journal!.title : 'Create journal',
              style: TextStyle(
                fontSize: 20
              )
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: _submit, 
            child: Text(
              'Save',
            )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              minLines: 1,
              maxLines: 5,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Title'
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _bodyController,
              maxLines: null,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                fontSize: 16
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'What do you wanna write about ...'
              ),
            )
          ]
        )
      )
    );
  }
}
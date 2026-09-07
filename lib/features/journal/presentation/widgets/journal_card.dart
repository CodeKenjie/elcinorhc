import 'package:elcinorch/features/tag/presentation/controllers/tag_controller.dart';
import 'package:elcinorch/features/tag/domain/entities/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/journal.dart';
import '../controllers/journal_tag_controller.dart';
import 'journal_tag_form_dialog.dart';

class JournalCard extends StatefulWidget {
  final Journal journal;
  final JournalTagController journalTagController;
  final TagController tagController;
  final Function(BuildContext)? onDelete;
  final Function()? onTap;
  const JournalCard({
    super.key,
    required this.journal,
    required this.journalTagController,
    required this.tagController,
    this.onDelete,
    this.onTap,
  });

  @override
  State<JournalCard> createState() => _JournalCardState();
}

class _JournalCardState extends State<JournalCard> {
  List<Tag> _tags = [];

  @override
  void initState() {
    super.initState();

    _loadJournalTags();
  }

  Future<void> _loadJournalTags() async {
    final tags = await widget.tagController.getJournalTags(widget.journal.id);
    if(!mounted) return;
    setState(() {
      _tags = tags;
    });
  }

  Future<void> _removeTag(int tagId) async {
    await widget.journalTagController.delete(journalId: widget.journal.id, tagId: tagId);
    await _loadJournalTags();
  }

  Future<void> _openAddTagDialog() async {
    await showDialog(
      context: context, 
      builder: (context) => JournalTagFormDialog(
        journalId: widget.journal.id, 
        controller: widget.journalTagController
      )
    );
    await _loadJournalTags();
  }

  String _formattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy EEE').format(date).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: widget.onDelete,
            icon: Icons.delete_rounded,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.redAccent
          )
        ],
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.book, size: 20, color: Theme.of(context).colorScheme.surface)
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.journal.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          _formattedDate(widget.journal.createdAt),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary
                          ),
                        ),
                      ],
                    )
                  )
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ... _tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(tag.name),
                            const SizedBox(width: 5),
                            GestureDetector(
                              child: Icon(Icons.remove, size: 14),
                              onTap: () => _removeTag(tag.id),
                            )
                          ],
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: _openAddTagDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 14),
                            const SizedBox(width: 5),
                            Text('Add tag')
                          ],
                        ),
                      )
                    )
                  ],
                )
              )
            ],
          )
        )
      )
    );
  }
}
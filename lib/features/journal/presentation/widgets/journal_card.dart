import 'package:elcinorch/features/journal/presentation/controllers/journal_controller.dart';
import 'package:elcinorch/features/tag/presentation/controllers/tag_controller.dart';
import 'package:elcinorch/features/tag/domain/entities/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/journal.dart';
import '../controllers/journal_tag_controller.dart';
import 'journal_tag_form_dialog.dart';
import 'package:elcinorch/app/dependencies.dart';

class JournalCard extends StatefulWidget {
  final Journal journal;
  final JournalController controller;
  final JournalTagController journalTagController;
  final TagController tagController;
  final Function(BuildContext)? onDelete;
  final Function()? onTap;
  const JournalCard({
    super.key,
    required this.journal,
    required this.controller,
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
  final authController = AppDependencies.authController;

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

  Future<void> _share() async {
    if (widget.controller.isLoading) return;

    final user = authController.user;
    bool success;

    if(user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You must be logged in to share a journal.')));
      return;
    }

    success = await widget.controller.shareJournal(userUid: user.uid, journal: widget.journal);

    if(!mounted) return;

    if(success){
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          leading: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.secondary),
          content: Text(
            'Shared ${widget.journal.title} to the public everyone can now see your journal',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary
            ),
          ), 
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              onPressed: (){
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              }, 
              icon: Icon(Icons.close, color: Theme.of(context).colorScheme.secondary),
            )
          ],
        )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.controller.errorMessage ?? 'Something went wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authController, 
      builder: (context, child) {
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
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 76, 175, 142),
                        child: Icon(Icons.book, size: 20, color: Theme.of(context).colorScheme.surface),
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
                      ),
                      if(authController.isLoggedIn) ... [
                        GestureDetector(
                          onTap: _share,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 76, 175, 142),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: widget.controller.isSharing(widget.journal.id)
                              ? SizedBox(
                                width: 20, 
                                height: 20, 
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.secondary
                                ) 
                              ) : Row(
                                children: [
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.secondary
                                    )
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(Icons.public, size: 14, color: Theme.of(context).colorScheme.secondary)
                                ],
                              )
                          )
                        )
                      ]
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(55, 67, 136, 111),
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
                              color: const Color.fromARGB(255, 76, 175, 142),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(tag.name, style: TextStyle(color: Colors.white)),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  child: Icon(Icons.remove, size: 14, color: Colors.white),
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
                              borderRadius: BorderRadius.circular(10)
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
                  ),
                ],
              )
            )
          )
        );
      }
    );
  }
}
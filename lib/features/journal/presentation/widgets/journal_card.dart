import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/journal.dart';

class JournalCard extends StatelessWidget {
  final Journal journal;
  final Function(BuildContext)? onDelete;
  final Function()? onTap;
  const JournalCard({
    super.key,
    required this.journal,
    this.onDelete,
    this.onTap
  });

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
            onPressed: onDelete,
            icon: Icons.delete_rounded,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.redAccent
          )
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Row(
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
                      journal.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      _formattedDate(journal.createdAt),
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
        )
      )
    );
  }
}
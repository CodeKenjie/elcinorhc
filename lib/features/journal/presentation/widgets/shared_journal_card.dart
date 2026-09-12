import 'package:elcinorch/features/auth/domain/entities/user.dart';
import 'package:elcinorch/features/journal/domain/entities/shared_journal.dart';
import 'package:elcinorch/features/journal/presentation/controllers/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SharedJournalCard extends StatelessWidget {
  final SharedJournal shared;
  final JournalController controller;
  final User user;
  final Function()? onDelete;
  const SharedJournalCard({
    super.key,
    required this.shared,
    required this.controller,
    required this.user,
    this.onDelete
  });

  String nameInitial(String firstName) {
    if(firstName.contains(" ")) {
      final List<String> name = firstName.trim().split(RegExp(r'\s+'));
      return "${name[0][0].toUpperCase()}${name[1][0].toUpperCase()}";
    } else {
      return firstName[0].toUpperCase();
    }
  }

  String _formattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date).toString();
  }

  String _capitalize(String string) {
    return string.trim().split(RegExp(r'\s+')).map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}').join(" ");
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.secondary
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color.fromARGB(255, 76, 175, 142),
                child: Text(nameInitial(user.firstName), style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${_capitalize(user.firstName)} ${_capitalize(user.lastName)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.tertiary
                      ),
                    ),
                  ],
                ),
              ),
              if(onDelete != null) ... [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: onDelete, 
                      icon: controller.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : Icon(Icons.delete, size: 14, color: Colors.redAccent)
                    ),
                  ],
                )
              ]
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'shared: ${_formattedDate(shared.sharedAt)}',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.tertiary
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  shared.journal.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  shared.journal.body,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';
import '../widgets/shared_journal_card.dart';

class PublicJournalsPage extends StatefulWidget {
  const PublicJournalsPage({super.key});

  @override
  State<PublicJournalsPage> createState() => _PublicJournalPageState();
}

class _PublicJournalPageState extends State<PublicJournalsPage> {
  final journalController = AppDependencies.journalController;
  final authController = AppDependencies.authController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    if(!authController.isLoggedIn) return;
    await journalController.getSharedJournal();
    if(!authController.isLoggedIn) return;
    await authController.loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        journalController,
        authController
      ]), 
      builder: (context, child) {
        final publicJournals = [...journalController.sharedJournals]..sort((a, b) => b.sharedAt.compareTo(a.sharedAt));
        final users = authController.users;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
              itemCount: publicJournals.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                final journal = publicJournals[index];
                final matchingUsers = users.where((user) => user.uid == journal.userUid);
                if(matchingUsers.isEmpty) {
                  return const SizedBox.shrink();
                }
                final user = matchingUsers.first;
                return SharedJournalCard(
                  shared: journal, 
                  controller: journalController, 
                  user: user
                );
              },
            ),
          )
        );
      }
    );
  }
}
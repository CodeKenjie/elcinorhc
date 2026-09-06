import 'package:elcinorch/app/dependencies.dart';
import 'package:elcinorch/features/journal/presentation/widgets/journal_form_page.dart';
import 'package:flutter/material.dart';
import '../widgets/journal_card.dart';

class JournalListPage extends StatefulWidget {
  const JournalListPage({ super.key });

  @override
  State<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  final journalController = AppDependencies.journalController;

  @override
  void initState(){
    super.initState();
    _loadJournals();
  }

  void _loadJournals() async {
    await journalController.getJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text ('Journals', 
              style: TextStyle(
                fontSize: 16, 
                color: Theme.of(context).colorScheme.tertiary
              )
            ),
            const SizedBox(height: 10),
            Expanded(
              child: AnimatedBuilder(
                animation: journalController,
                builder: (context, child) {
                  final journals = journalController.journals.toList();
                  return ListView.builder(
                    itemCount: journals.length,
                    itemBuilder: (context, index) {
                      final journal = journals[index];
                      return JournalCard(
                        journal: journal,
                        onDelete: (context) async {
                          await journalController.delete(journal.id);
                        },
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => JournalFormPage(
                                journal: journal,
                                controller: journalController
                              )
                            )
                          );
                        },
                      );
                    }
                  );
                }
              )
            ),
            GestureDetector (
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => JournalFormPage(
                    controller: journalController,
                  )
                ));
              }, 
              child: Container (
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
                    const SizedBox(width: 8),
                    Text(
                      'Create journal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface
                      ),
                    )
                  ],
                )
              )
            )
          ],
        )
      )
    );
  }
}
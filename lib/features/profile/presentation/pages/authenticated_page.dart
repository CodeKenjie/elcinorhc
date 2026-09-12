import 'package:elcinorch/features/journal/presentation/widgets/shared_journal_card.dart';
import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';
import 'package:intl/intl.dart';
import '../../../progress/presentation/widgets/task_progress_card.dart';
import '../../../progress/presentation/widgets/journal_progress_card.dart';
import '../../../progress/presentation/widgets/streak_card.dart';

class AuthenticatedPage extends StatefulWidget {
  const AuthenticatedPage({super.key});

  @override
  State<AuthenticatedPage> createState() => _AuthenticatedPageState();
}

class _AuthenticatedPageState extends State<AuthenticatedPage> {
  final authController = AppDependencies.authController;
  final progressController = AppDependencies.progressController;
  final journalController = AppDependencies.journalController;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    await progressController.loadProgress();
    await journalController.getSharedJournal();
  }

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
    return AnimatedBuilder(
      animation: Listenable.merge([ authController, progressController, journalController ]), 
      builder: (context, child) {
        final user = authController.user;
        final progress = progressController.progress;
        final sharedJournals = journalController.sharedJournals;
        if(progress == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if(user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final planner = progress.planner;
        final journal = progress.journal;
        final userSharedJournal = sharedJournals.where((journal) => journal.userUid == user.uid).toList();

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color.fromARGB(255, 76, 175, 142),
                          child: Text(nameInitial(user.firstName), style: TextStyle(fontSize: 30)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _capitalize("${user.firstName} ${user.lastName}"),
                                style: TextStyle(
                                  fontSize: 24
                                ),
                              ),
                              Text(
                                user.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.tertiary
                                ),
                              ),
                              Text(
                                _formattedDate(user.dateOfBirth),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.tertiary
                                ),
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                  StreakCard(progress: journal),
                  TaskProgressCard(progress: planner),
                  JournalProgressCard(progress: journal),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: userSharedJournal.length,
                    separatorBuilder:(context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder:(context, index) {
                      final publicJournal = userSharedJournal[index];
                      return SharedJournalCard(
                        shared: publicJournal, 
                        controller: journalController,
                        user: user,
                        onDelete: () async {
                          await journalController.deleteSharedJournal(publicJournal.uid);
                        },
                      );
                    },
                  )
                ],
              )
            ),
          ),
        );   
      }
    );
  }
}
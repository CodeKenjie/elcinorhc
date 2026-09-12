import 'package:flutter/material.dart';
import 'package:elcinorch/features/auth/presentation/pages/sign_in_page.dart';
import 'package:elcinorch/features/auth/presentation/pages/sign_up_page.dart';
import 'package:elcinorch/app/dependencies.dart';
import '../../../progress/presentation/widgets/task_progress_card.dart';
import '../../../progress/presentation/widgets/journal_progress_card.dart';
import '../../../progress/presentation/widgets/streak_card.dart';

class UnauthenticatedPage extends StatefulWidget {
  const UnauthenticatedPage({super.key});

  @override
  State<UnauthenticatedPage> createState() => _UnauthenticatedPageState();
}

class _UnauthenticatedPageState extends State<UnauthenticatedPage> {
  final progressController = AppDependencies.progressController;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    await progressController.loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progressController, 
      builder: (context, child)  {
        if(progressController.isLoading) {
          return Center(
            child: CircularProgressIndicator()
          );
        }

        if(progressController.errorMessage != null) {
          return Center(
            child: Text(progressController.errorMessage ?? "something went wrong")
          );
        }

        final progress = progressController.progress;

        if(progress == null) {
          return const SizedBox();
        }

        final planner = progress.planner;
        final journal = progress.journal;

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'E L C I N',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30)
                ),
                const Text(
                  'O R H C', 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30)
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => SignInPage())
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 76, 175, 142),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Center(
                      child: Text(
                        'I already have an account', 
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      )
                    )
                  )
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage()
                      )
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Center(
                      child: Text(
                        'I want to make an account', 
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    )
                  )
                ),
                const SizedBox(height: 20),
                StreakCard(progress: journal),
                TaskProgressCard(progress: planner),
                JournalProgressCard(progress: journal),
              ],
            ),
          )
        );
      }
    );
  }
}
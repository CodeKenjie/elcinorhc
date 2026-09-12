import 'package:elcinorch/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/todo/presentation/pages/undone_todo_list_page.dart';
import '../features/todo/presentation/pages/completed_todo_list_page.dart';
import '../features/plan/presentation/pages/plan_page.dart';
import '../features/journal/presentation/pages/journal_list_page.dart';
import '../features/tag/presentation/pages/tag_list_page.dart';
import '../features/profile/presentation/pages/profile_state.dart';
import 'theme/theme.dart';
import 'dependencies.dart';

class Elcinorhc extends StatefulWidget {
  const Elcinorhc({super.key});

  @override
  State<Elcinorhc> createState() => _ElcinorhcState();
}

class _ElcinorhcState extends State<Elcinorhc> {
  int _currentIndex = 0;
  final authController = AppDependencies.authController;

  final List<Widget> _pages = [
    UndoneTodoListPage(),
    PlanPage(),
    JournalListPage(),
    ProfileState(),
  ];

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: ThemeMode.system,
      routes: {
        '/completed_task': (context) => CompletedTodoListPage(),
        '/tag_list': (context) => TagListPage(),
      },
      home: Scaffold(      
        appBar: AppBar(
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
          actions: [
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:  const Color.fromARGB(255, 76, 175, 142)
                ),
                child: Icon(Icons.notifications, color: Colors.white),
              ),
            )
          ],
        ),
        drawerScrimColor: Colors.black12,
        drawer: Builder(
          builder: (context) {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(), 
              builder: (context, snapshot) {
                return Drawer(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                        ),
                        child: Column(
                          children: [
                            Text('E L C I N', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('O R H C', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ]
                        )
                      ),
                      ListTile(
                        leading: Icon(Icons.task_alt),
                        title: Text('Completed tasks'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/completed_task');
                        }
                      ),
                      ListTile(
                        leading: Icon(Icons.label_outline),
                        title: Text('Tags'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/tag_list');
                        }
                      ),
                      const Spacer(),
                      ListenableBuilder(
                        listenable: authController, 
                        builder: (context, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if(snapshot.hasData) ... [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await authController.signOut();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(255, 76, 175, 142)
                                      ),
                                      child: authController.isLoading 
                                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary))
                                        : Text(
                                          'Logout',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white
                                          ),
                                      )
                                    ),
                                  ),
                                )
                              ] else ... [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(builder: (context) => SignInPage())
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(255, 76, 175, 142)
                                      ),
                                      child: Text(
                                        'Sign in',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white
                                        ),
                                      )
                                    ),
                                  ),
                                )
                              ]
                            ],
                          );
                        }
                      ),
                      const SizedBox(height: 50)
                    ]
                  ),
                );
              }
            );
          }
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: NavigationBar(
          height: 50,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today),
              label: 'Planner',
            ),
            NavigationDestination(
              icon: Icon(Icons.book_outlined),
              selectedIcon: Icon(Icons.book_rounded),
              label: 'Journal',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              selectedIcon: Icon(Icons.person),
              label: 'Me',
            ),
          ]
        ),
      )
    );
  }
}
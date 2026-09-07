import 'package:flutter/material.dart';
import '../features/todo/presentation/pages/undone_todo_list_page.dart';
import '../features/todo/presentation/pages/completed_todo_list_page.dart';
import '../features/plan/presentation/pages/plan_page.dart';
import '../features/journal/presentation/pages/journal_list_page.dart';
import '../features/tag/presentation/pages/tag_list_page.dart';
import 'theme/theme.dart';

class Elcinorhc extends StatefulWidget {
  const Elcinorhc({super.key});

  @override
  State<Elcinorhc> createState() => _ElcinorhcState();
}

class _ElcinorhcState extends State<Elcinorhc> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    UndoneTodoListPage(),
    PlanPage(),
    JournalListPage(),
    Center(child: Text('Profile page')),
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
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {}, 
            )
          ],
        ),
        drawerScrimColor: Colors.black12,
        drawer: Builder(
          builder: (context) {
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
                  )
                ]
              ),
            );
          }
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: NavigationBar(
          height: 40,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
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
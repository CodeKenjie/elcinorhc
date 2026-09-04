import 'package:flutter/material.dart';
import '../features/daily/presentation/pages/daily_page.dart';
import '../features/plan/presentation/pages/plan_page.dart';

class Elcinorhc extends StatefulWidget {
  const Elcinorhc({super.key});

  @override
  State<Elcinorhc> createState() => _ElcinorhcState();
}

class _ElcinorhcState extends State<Elcinorhc> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DailyPage(),
    PlanPage(),
    Center(child: Text('Journal page')),
    Center(child: Text('Profile page')),
  ];

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        drawer: Drawer(
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
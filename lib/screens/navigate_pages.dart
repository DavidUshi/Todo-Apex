import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/add_screen.dart';
import 'package:flutter_application_2/screens/home_screen.dart';
import 'package:flutter_application_2/screens/today_screen.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;

  void _nevigateButtomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [HomeScreen(), AddScreen(), Today()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: const Color.fromARGB(189, 255, 255, 255),
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        selectedLabelStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        unselectedFontSize: 14,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black54,
        currentIndex: _selectedIndex,
        iconSize: 24,
        elevation: 1,
        onTap: _nevigateButtomBar,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),

          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: 'Done',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Today',
          ),
        ],
      ),
    );
  }
}

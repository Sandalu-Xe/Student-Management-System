import 'package:flutter/material.dart';
import 'create_student.dart';
import 'view_students.dart';
import 'delete_students.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CreateStudent(),
    ViewStudents(),
    DeleteStudents(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Hub'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        indicatorColor: Colors.amber.withOpacity(0.2),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.add_circle, color: Colors.indigo),
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Student',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.list_alt, color: Colors.indigo),
            icon: Icon(Icons.list_alt_outlined),
            label: 'Students',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.delete_forever, color: Colors.red),
            icon: Icon(Icons.delete_outline),
            label: 'Remove',
          ),
        ],
      ),
    );
  }
}

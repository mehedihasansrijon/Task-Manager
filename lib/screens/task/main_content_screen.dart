import 'package:flutter/material.dart';
import 'package:task_manager/screens/task/canceled_list_screen.dart';
import 'package:task_manager/screens/task/completed_list_screen.dart';
import 'package:task_manager/screens/task/new_task_list_screen.dart';
import 'package:task_manager/screens/task/progress_task_list_screen.dart';
import 'package:task_manager/component/tm_app_bar.dart';

class MainContentScreen extends StatefulWidget {
  const MainContentScreen({super.key});

  @override
  State<MainContentScreen> createState() => _MainContentScreenState();
}

class _MainContentScreenState extends State<MainContentScreen> {
  int _selectedBottomIndex = 0;

  final List _screens = [
    const NewTaskListScreen(),
    const CompletedListScreen(),
    const CanceledListScreen(),
    const ProgressListScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedBottomIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedBottomIndex,
        onDestinationSelected: (value) {
          _selectedBottomIndex = value;
          setState(() {});
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'New Task',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            label: 'Completed',
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel_outlined),
            label: 'Canceled',
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time_outlined),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}

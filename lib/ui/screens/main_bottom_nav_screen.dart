import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../widgets/tm_app_bar.dart';
import 'cancel_task_screen.dart';
import 'completed_task_screen.dart';
import 'in_progress_task_screen.dart';
import 'new_task_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 0;
  final List<Widget> _screens = [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelTaskScreen(),
    InProgressTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        onUpdate: () {
          setState(() {});
          Logger().w('Got the notifier from mainBottom ');
        },
      ),
      body: _screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          selectedIndex = index;
          setState(() {});
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.newspaper, color: Colors.blue),
            label: 'New',
          ),
          NavigationDestination(
            icon: Icon(Icons.deblur_sharp, color: Colors.green),
            label: 'Completed',
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel, color: Colors.redAccent),
            label: 'Canceled',
          ),
          NavigationDestination(
            icon: Icon(Icons.run_circle_rounded, color: Colors.purple),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}

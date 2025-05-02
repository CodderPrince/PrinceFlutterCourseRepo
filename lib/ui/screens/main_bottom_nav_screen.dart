import 'package:flutter/material.dart';
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
    InProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
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
            icon: Icon(Icons.run_circle_rounded, color: Colors.purple),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_rounded, color: Colors.green),
            label: 'Completed',
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel, color: Colors.redAccent),
            label: 'Canceled',
          ),
        ],
      ),
    );
  }
}

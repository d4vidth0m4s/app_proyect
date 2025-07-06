import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/programs_screen.dart';
import '../screens/alerts_screen.dart';
import '/constants/app_constants.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ProgramsScreen(),
    const AlertScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(icon: Icons.home_outlined, label: 'Inicio', index: 0),
                _buildNavItem(icon: Icons.list_alt_outlined, label: 'Programas', index: 1),
                _buildNavItem(icon: Icons.warning_amber_outlined, label: 'Alertas', index: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildNavItem({
  required IconData icon,
  required String label,
  required int index,
}) {
  final bool isSelected = _currentIndex == index;

  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      setState(() {
        _currentIndex = index;
      });
    },
    child: Container(
      
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isSelected)
                Container(
                  width: 45,
                  height: 45,
                 
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.black : Colors.grey,
                  size: 25,
                ),
              ),
            ],
          ),
          if (isSelected) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
 
}

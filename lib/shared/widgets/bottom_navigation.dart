import 'package:flutter/material.dart';
import 'package:app_proyect/features/home/home_screen.dart';
import 'package:app_proyect/features/programs/programs_screen.dart';
import 'package:app_proyect/features/alerts/alerts_screen.dart';
import 'package:app_proyect/features/settings/settings_screen.dart';
import 'package:app_proyect/core/constants/app_constants.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  static const double _gradientInitialStop = 0.0;
  static const double _gradientPercent1 = 0.35;
  static const double _gradientPercent2 = 0.75;
  static const double _gradientPercent3 = 1;
  static const double _navIconsTopOffset = 35.0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ProgramsScreen(),
    const AlertScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(index: _currentIndex, children: _pages),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            
            child: SizedBox(
              height: 90 + bottomInset,
              child: Stack(
                children: [
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.background.withValues(alpha: 0),
                            AppColors.background.withValues(alpha: 0.55),
                            AppColors.background.withValues(alpha: 0.99),
                            AppColors.background,
                          ],
                          stops: [
                            _gradientInitialStop,
                            _gradientPercent1,
                            _gradientPercent2,
                            _gradientPercent3,
                          ],
                        ),
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: _navIconsTopOffset,
                      bottom: bottomInset,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          icon: Icons.home_outlined,
                          index: 0,
                        
                        ),
                        _buildNavItem(
                          icon: Icons.list_alt_outlined,
                          index: 1,
                        
                        ),
                        _buildNavItem(
                          icon: Icons.warning_amber_outlined,
                          index: 2,
                          
                        ),
                        _buildNavItem(
                          icon: Icons.settings,
                          index: 3,
                          
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,

  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryVariant : Colors.grey,
                size: 25,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

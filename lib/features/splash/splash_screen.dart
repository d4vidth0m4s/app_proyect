import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/models/layout_box.dart';
import 'package:app_proyect/core/utils/calculate_layout_values.dart';
import 'package:app_proyect/data/local/preferences/shared_preferences_service.dart';
import 'package:app_proyect/shared/widgets/decoration.dart';
import 'package:flutter/material.dart';
import 'package:app_proyect/features/splash/onboarding/onboarding_screen.dart';
import 'package:app_proyect/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _scaleAnimation;

  bool _isFirstTime = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation =
        Tween<Offset>(
          begin: Offset.zero, // PosiciÃ³n inicial (0, 0)
          end: const Offset(-1, -1), // PosiciÃ³n final (esquina opuesta)
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOutCubicEmphasized, // Curva suave
          ),
        );
  }

  void _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));
    await SharedPreferencesService.clearAll();
    final isFirstTime = await SharedPreferencesService.isFirstTime();

    if (!mounted) return;

    setState(() {
      _isFirstTime = isFirstTime;
    });

    if (_isFirstTime) {
      _animationController.forward(); // solo animar si es la primera vez
    }

    await Future.delayed(const Duration(seconds: 2));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            _isFirstTime ? const OnboardingScreen() : const MainScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final layoutValues = calculateLayoutValues(screenSize);
    final valuesGreen = relativeValues(
      x: screenSize.width * .86,
      y: screenSize.height * 0.84,
      angle: 27.634 * (3.14159 / 180),
      color: AppColors.primary,
    );
    final valuesPink = relativeValues(
      x: screenSize.width * .6,
      y: screenSize.height * 0.85,
      angle: -167.284 * (3.14159 / 180),
      color: AppColors.secondary,
    );

    return Center(
      child: Container(
        width: layoutValues.containerWidth,
        height: layoutValues.containerHeight,
        decoration: BoxDecoration(color: AppColors.secondaryVariant),
        child: ClipRRect(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return buildDecoration(
                    layoutValues,
                    _scaleAnimation,
                    valuesGreen,
                    1,
                  );
                },
              ),

              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return buildDecoration(
                    layoutValues,
                    _scaleAnimation,
                    valuesPink,
                    2,
                  );
                },
              ),
              _buildIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final screenSize = MediaQuery.of(context).size;
    return Positioned(
      left: screenSize.width * .95 - screenSize.width * .9,
      top: screenSize.height * .70 - screenSize.height * .4,

      child: AppIcons.user(
        height: screenSize.height * .4,
        width: screenSize.width * .9,
      ),
    );
  }
}

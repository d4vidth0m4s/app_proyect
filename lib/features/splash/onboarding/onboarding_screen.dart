import 'package:app_proyect/models/layout_box.dart';
import 'package:app_proyect/core/utils/calculate_layout_values.dart';
import 'package:app_proyect/shared/widgets/decoration.dart';
import 'package:app_proyect/data/local/preferences/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:app_proyect/core/constants/app_constants.dart';
import 'package:app_proyect/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _scaleAnimation;
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bienvenido',
      description: 'Descubre todas las funcionalidades que tenemos para ti',
      icon: Icons.waving_hand,
      color: AppColors.primary,
    ),
    OnboardingPage(
      title: 'Conecta con IA',
      description:
          'Chatea con nuestra inteligencia artificial y obtÃ©n respuestas rÃ¡pidas',
      icon: Icons.chat_bubble_outline,
      color: AppColors.secondary,
    ),
    OnboardingPage(
      title: 'Gestiona tu tiempo',
      description:
          'Lleva un registro de tus actividades y mejora tu productividad',
      icon: Icons.access_time,
      color: AppColors.accent,
    ),
  ];

  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation =
        Tween<Offset>(
          begin: Offset.zero, // PosiciÃ³n inicial (0, 0)
          end: const Offset(1, 1), // PosiciÃ³n final (esquina opuesta)
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOutCubicEmphasized, // Curva suave
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    await SharedPreferencesService.setFirstTime(false);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
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
    return Container(
      decoration: BoxDecoration(color: AppColors.secondaryVariant),
      child: ClipRRect(
        child: Stack(
          children: [
            buildDecoration(layoutValues, null, valuesGreen, 1),
            buildDecoration(layoutValues, null, valuesPink, 2),
            Positioned(
              top: layoutValues.containerHeight * .31,

              child: AnimatedBuilder(
                animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(
                        _scaleAnimation.value.dx * 0,
                        _scaleAnimation.value.dy * -100,
                      ),
                      child: _buildcontainer(layoutValues),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildcontainer(LayoutValues layoutValues) {
    return Container(
      width: layoutValues.containerWidth,
      height: layoutValues.containerHeight * 0.8,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(layoutValues.borderRadius),
          topRight: Radius.circular(layoutValues.borderRadius),
        ),
      ),
      child: _buildonboarding(),
    );
  }

  Widget _buildonboarding() {
    return Column(
      children: [
        // BotÃ³n Skip en la esquina superior derecha
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_currentIndex < _pages.length - 1)
                TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text(
                    'Saltar',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
        // PageView con las pÃ¡ginas de onboarding
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
        ),
        // Indicadores de pÃ¡gina
        _buildPageIndicators(),
        // BotÃ³n continuar
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: _pages[_currentIndex].color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                _currentIndex == _pages.length - 1 ? 'Comenzar' : 'Siguiente',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono principal
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 60, color: page.color),
          ),
          const SizedBox(height: 50),
          // TÃ­tulo
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // DescripciÃ³n
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _pages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 8,
            width: _currentIndex == index ? 24 : 8,
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? _pages[_currentIndex].color
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

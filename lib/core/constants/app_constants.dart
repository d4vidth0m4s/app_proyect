import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';

class AppColors {
  static const Color primary = Color(0xFF21F3BF);
  static const Color primaryVariant = Color(0xFF0C58B8);
  static const Color secondary = Color(0xFFE14BA4);
  static const Color secondaryVariant = Color(0xFFE1FF4A);
  static const Color accent = Color(0xFFFF9800);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0x1E000000);
  static const Color onError = Color(0xFFFFFFFF);

  // Colores adicionales para el onboarding
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);

  // Colores para botones y elementos interactivos
  static const Color buttonPrimary = Color(0xFF2196F3);
  static const Color buttonSecondary = Color(0xFF757575);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Colores para el splash screen
  static const Color splashGradientStart = Color(0xFF2196F3);
  static const Color splashGradientEnd = Color(0xFF1976D2);
}

class AppIcons {
  static Widget user({
    double width = 40,
    double height = 40,
    bool start = true,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: RiveAnimation.asset(
        'assets/animate/logo.riv',
        fit: BoxFit.contain,
        antialiasing: true,
        onInit: (artboard) => _onRiveInit(artboard, start),
      ),
    );
  }

  static void _onRiveInit(Artboard artboard, bool start) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    if (controller != null) {
      artboard.addController(controller);
      final input = controller.findInput<bool>('animation');
      input?.value = start;
    }
  }
}

class AppStrings {
  // Splash Screen
  static const String appName = 'Mi App';
  static const String appDescription = 'Bienvenido a tu aplicación';
  static const String loading = 'Cargando...';

  // Onboarding
  static const String skip = 'Saltar';
  static const String next = 'Siguiente';
  static const String start = 'Comenzar';
  static const String previous = 'Anterior';

  // Onboarding content
  static const String onboardingTitle1 = 'Bienvenido';
  static const String onboardingDescription1 =
      'Descubre todas las funcionalidades que tenemos para ti';

  static const String onboardingTitle2 = 'Conecta con IA';
  static const String onboardingDescription2 =
      'Chatea con nuestra inteligencia artificial y obtén respuestas rápidas';

  static const String onboardingTitle3 = 'Gestiona tu tiempo';
  static const String onboardingDescription3 =
      'Lleva un registro de tus actividades y mejora tu productividad';

  // Botones generales
  static const String accept = 'Aceptar';
  static const String cancel = 'Cancelar';
  static const String ok = 'OK';
  static const String save = 'Guardar';
  static const String delete = 'Eliminar';
  static const String edit = 'Editar';
  static const String add = 'Agregar';
  static const String remove = 'Remover';
  static const String update = 'Actualizar';
  static const String refresh = 'Actualizar';
  static const String retry = 'Reintentar';
  static const String back = 'Volver';
  static const String done = 'Listo';
  static const String finish = 'Finalizar';
}

class AppSizes {
  // Padding y margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Border radius
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 12.0;
  static const double borderRadiusXL = 16.0;
  static const double borderRadiusRound = 50.0;

  // Iconos
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // Botones
  static const double buttonHeight = 48.0;
  static const double buttonHeightS = 32.0;
  static const double buttonHeightL = 56.0;

  // Espaciado
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;
}

class AppDurations {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
  static const Duration extraLong = Duration(milliseconds: 1000);

  // Duraciones específicas
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration transitionDuration = Duration(milliseconds: 250);
}

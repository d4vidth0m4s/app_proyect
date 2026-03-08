import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _firstTimeKey = 'first_time';

  /// Verifica si es la primera vez que se abre la app
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstTimeKey) ?? true;
  }

  /// Marca que ya no es la primera vez que se abre la app
  static Future<void> setFirstTime(bool isFirstTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, isFirstTime);
  }

  /// Limpia todos los datos guardados (útil para testing)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Resetea el onboarding para que se muestre de nuevo
  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, true);
  }
}

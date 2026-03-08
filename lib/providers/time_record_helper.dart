import 'package:app_proyect/models/time_record.dart';
import 'package:app_proyect/data/local/hive/time_record_manager.dart';

// Funciones auxiliares para usar en tu aplicaciÃ³n
class TimeRecordHelper {
  static TimeRecordManager? _instance;

  static Future<TimeRecordManager> getInstance() async {
    if (_instance == null) {
      _instance = TimeRecordManager();
      await _instance!.init();
    }
    return _instance!;
  }

  // FunciÃ³n simple para llamar desde cualquier parte de tu app
  static Future<void> registrarTiempo(int timeMilis) async {
    TimeRecordManager manager = await getInstance();
    await manager.registrarTiempo(timeMilis);
  }

  // Obtener estadÃ­sticas del dÃ­a actual
  static Future<TimeRecord?> obtenerRegistroHoy() async {
    TimeRecordManager manager = await getInstance();
    String fechaHoy =
        '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}';
    return manager.obtenerRegistroPorFecha(fechaHoy);
  }

  // Obtener todos los registros
  static Future<List<TimeRecord>> obtenerTodosLosRegistros() async {
    TimeRecordManager manager = await getInstance();
    return manager.obtenerTodosLosRegistros();
  }

  // Obtener registro por fecha especÃ­fica
  static Future<TimeRecord?> obtenerRegistroPorFecha(String fecha) async {
    TimeRecordManager manager = await getInstance();
    return manager.obtenerRegistroPorFecha(fecha);
  }

  // Limpiar todos los registros
  static Future<void> limpiarRegistros() async {
    TimeRecordManager manager = await getInstance();
    await manager.limpiarRegistros();
  }

  // Mostrar estadÃ­sticas
  static Future<void> mostrarEstadisticas() async {
    TimeRecordManager manager = await getInstance();
    manager.mostrarEstadisticas();
  }

  // Insertar datos de semilla
  static Future<void> seedData() async {
    TimeRecordManager manager = await getInstance();
    await manager.seedData();
  }

  // Cerrar la conexiÃ³n
  static Future<void> cerrar() async {
    if (_instance != null) {
      await _instance!.cerrar();
      _instance = null;
    }
  }
}

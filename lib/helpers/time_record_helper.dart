import '../models/time_record.dart';
import '../servicie/time_record_manager.dart';

// Funciones auxiliares para usar en tu aplicación
class TimeRecordHelper {
  static TimeRecordManager? _instance;
  
  static Future<TimeRecordManager> getInstance() async {
    if (_instance == null) {
      _instance = TimeRecordManager();
      await _instance!.init();
    }
    return _instance!;
  }
  
  // Función simple para llamar desde cualquier parte de tu app
  static Future<void> registrarTiempo(int timeMilis) async {
    TimeRecordManager manager = await getInstance();
    await manager.registrarTiempo(timeMilis);
  }
  
  // Obtener estadísticas del día actual
  static Future<TimeRecord?> obtenerRegistroHoy() async {
    TimeRecordManager manager = await getInstance();
    String fechaHoy = DateTime.now().day.toString().padLeft(2, '0') + 
                     '/' + DateTime.now().month.toString().padLeft(2, '0');
    return manager.obtenerRegistroPorFecha(fechaHoy);
  }
  
  // Obtener todos los registros
  static Future<List<TimeRecord>> obtenerTodosLosRegistros() async {
    TimeRecordManager manager = await getInstance();
    return manager.obtenerTodosLosRegistros();
  }
  
  // Obtener registro por fecha específica
  static Future<TimeRecord?> obtenerRegistroPorFecha(String fecha) async {
    TimeRecordManager manager = await getInstance();
    return manager.obtenerRegistroPorFecha(fecha);
  }
  
  // Limpiar todos los registros
  static Future<void> limpiarRegistros() async {
    TimeRecordManager manager = await getInstance();
    await manager.limpiarRegistros();
  }
  
  // Mostrar estadísticas
  static Future<void> mostrarEstadisticas() async {
    TimeRecordManager manager = await getInstance();
    manager.mostrarEstadisticas();
  }
  
  // Cerrar la conexión
  static Future<void> cerrar() async {
    if (_instance != null) {
      await _instance!.cerrar();
      _instance = null;
    }
  }
}
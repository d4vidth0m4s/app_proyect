import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/time_record.dart';

// Clase para manejar la lógica de la tabla
class TimeRecordManager {
  static const String _boxName = 'time_records';
  late Box<TimeRecord> _box;
  
  // Inicializar Hive y abrir la caja
  Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(TimeRecordAdapter());
    _box = await Hive.openBox<TimeRecord>(_boxName);
  }
  
  // Función principal para registrar tiempo
  Future<void> registrarTiempo(int nuevoTimeMilis) async {
    String fechaHoy = _getFechaActual();
    
    // Obtener el último registro
    TimeRecord? ultimoRegistro = _obtenerUltimoRegistro();
    
    if (ultimoRegistro != null && ultimoRegistro.fecha == fechaHoy) {
      // Si la fecha coincide, actualizar con promedio
      await _actualizarRegistroExistente(ultimoRegistro, nuevoTimeMilis);
    } else {
      // Si es una fecha nueva, crear nuevo registro
      await _crearNuevoRegistro(fechaHoy, nuevoTimeMilis);
    }
  }
  
  // Obtener fecha actual en formato DD/MM
  String _getFechaActual() {
    DateTime now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}";
  }
  
  // Obtener el último registro guardado
  TimeRecord? _obtenerUltimoRegistro() {
    if (_box.isEmpty) return null;
    
    // Buscar el registro más reciente
    TimeRecord? ultimoRegistro;
    for (var record in _box.values) {
      if (ultimoRegistro == null || _compararFechas(record.fecha, ultimoRegistro.fecha) >= 0) {
        ultimoRegistro = record;
      }
    }
    return ultimoRegistro;
  }
  
  // Comparar dos fechas en formato DD/MM
  int _compararFechas(String fecha1, String fecha2) {
    List<String> partes1 = fecha1.split('/');
    List<String> partes2 = fecha2.split('/');
    
    int dia1 = int.parse(partes1[0]);
    int mes1 = int.parse(partes1[1]);
    int dia2 = int.parse(partes2[0]);
    int mes2 = int.parse(partes2[1]);
    
    if (mes1 != mes2) {
      return mes1.compareTo(mes2);
    }
    return dia1.compareTo(dia2);
  }
  
  // Actualizar registro existente con promedio
  Future<void> _actualizarRegistroExistente(TimeRecord registro, int nuevoTimeMilis) async {
    int nuevoContador = registro.cont + 1;
    int tiempoTotal = (registro.timeMilis * registro.cont) + nuevoTimeMilis;
    int promedioTiempo = (tiempoTotal / nuevoContador).round();
    
    registro.cont = nuevoContador;
    registro.timeMilis = promedioTiempo;
    
    await registro.save();
    
    print('Registro actualizado: ${registro.toString()}');
  }
  
  // Crear nuevo registro
  Future<void> _crearNuevoRegistro(String fecha, int timeMilis) async {
    TimeRecord nuevoRegistro = TimeRecord(
      fecha: fecha,
      timeMilis: timeMilis,
      cont: 1,
    );
    
    await _box.add(nuevoRegistro);
    
    print('Nuevo registro creado: ${nuevoRegistro.toString()}');
  }
  
  // Obtener todos los registros
  List<TimeRecord> obtenerTodosLosRegistros() {
    return _box.values.toList();
  }
  
  // Obtener registro por fecha
  TimeRecord? obtenerRegistroPorFecha(String fecha) {
    for (var record in _box.values) {
      if (record.fecha == fecha) {
        return record;
      }
    }
    return null;
  }
  
  // Limpiar todos los registros
  Future<void> limpiarRegistros() async {
    await _box.clear();
  }
  
  // Cerrar la caja
  Future<void> cerrar() async {
    await _box.close();
  }
  
  // Mostrar estadísticas
  void mostrarEstadisticas() {
    print('\n=== ESTADÍSTICAS ===');
    print('Total de registros: ${_box.length}');
    
    for (var record in _box.values) {
      print('Fecha: ${record.fecha}, Tiempo promedio: ${record.timeMilis}ms, Llamadas: ${record.cont}');
    }
    print('==================\n');
  }
}
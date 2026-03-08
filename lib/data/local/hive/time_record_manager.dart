import 'package:hive_flutter/hive_flutter.dart';
import 'package:app_proyect/models/time_record.dart';

// Clase para manejar la lÃ³gica de la tabla
class TimeRecordManager {
  static const String _boxName = 'time_records';
  late Box<TimeRecord> _box;

  // Inicializar Hive y abrir la caja
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TimeRecordAdapter());

    try {
      _box = await Hive.openBox<TimeRecord>(_boxName);
    } catch (e) {
      await Hive.deleteBoxFromDisk(_boxName);
      _box = await Hive.openBox<TimeRecord>(_boxName);
    }
  }

  // FunciÃ³n principal para registrar tiempo
  Future<void> registrarTiempo(int nuevoTimeMilis) async {
    String fechaHoy = _getFechaActual();

    // Obtener el Ãºltimo registro
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
    const dias = ['L', 'M', 'X', 'J', 'V', 'S', 'D']; // Lunes a Domingo

    String inicialDia = dias[now.weekday - 1];
    String fecha =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}";

    return "$inicialDia-$fecha"; // Ej: M-06/07
  }

  // Obtener el Ãºltimo registro guardado
  TimeRecord? _obtenerUltimoRegistro() {
    if (_box.isEmpty) return null;

    // Buscar el registro mÃ¡s reciente
    TimeRecord? ultimoRegistro;
    for (var record in _box.values) {
      if (ultimoRegistro == null ||
          _compararFechas(record.fecha, ultimoRegistro.fecha) >= 0) {
        ultimoRegistro = record;
      }
    }
    return ultimoRegistro;
  }

  // Comparar dos fechas en formato DD/MM
  int _compararFechas(String fecha1, String fecha2) {
    try {
      // Separar por guion y obtener solo la parte de la fecha (DD/MM)
      final partesFecha1 = fecha1.split('-').last.split('/');
      final partesFecha2 = fecha2.split('-').last.split('/');

      final dia1 = int.parse(partesFecha1[0]);
      final mes1 = int.parse(partesFecha1[1]);

      final dia2 = int.parse(partesFecha2[0]);
      final mes2 = int.parse(partesFecha2[1]);

      final date1 = DateTime(2000, mes1, dia1);
      final date2 = DateTime(2000, mes2, dia2);

      return date1.compareTo(date2); // -1: antes, 0: igual, 1: despuÃ©s
    } catch (e) {
      print("âŒ Error al comparar '$fecha1' con '$fecha2': $e");
      return 0;
    }
  }

  // Actualizar registro existente con promedio
  Future<void> _actualizarRegistroExistente(
    TimeRecord registro,
    int nuevoTimeMilis,
  ) async {
    if (nuevoTimeMilis == 0) return; // No hacer nada si el tiempo es 0

    if (nuevoTimeMilis >= registro.lastTimeMilis) {
      // Es una sesiÃ³n continua, sumar la diferencia
      int diferencia = nuevoTimeMilis - registro.lastTimeMilis;
      registro.timeMilis += diferencia;
      registro.cont += 1;
      registro.lastTimeMilis = nuevoTimeMilis;
      await registro.save();
      ('âœ… Registro actualizado: ${registro.toString()}');
    } else {
      // Se reiniciÃ³ el micro, solo actualizamos el valor de referencia
      registro.lastTimeMilis = nuevoTimeMilis;
      await registro.save();
      print(
        'ðŸ”„ Micro reiniciado. Registro actualizado sin sumar: ${registro.toString()}',
      );
    }
  }

  // Crear nuevo registro
  Future<void> _crearNuevoRegistro(String fecha, int timeMilis) async {
    // Obtener el Ãºltimo registro guardado
    TimeRecord? ultimo = _obtenerUltimoRegistro();

    if (ultimo != null) {
      // Rellenar los dÃ­as faltantes con registros de timeMilis = 0
      final diasFaltantes = _generarFechasIntermedias(ultimo.fecha, fecha);
      for (final f in diasFaltantes) {
        await _box.add(
          TimeRecord(fecha: f, timeMilis: 0, lastTimeMilis: 0, cont: 1),
        );
        print('ðŸ•³ï¸ DÃ­a faltante agregado: $f');
      }
    }

    // Finalmente, agregar el nuevo registro real
    await _box.add(
      TimeRecord(fecha: fecha, timeMilis: timeMilis, lastTimeMilis: 0, cont: 1),
    );
    print('âœ… Nuevo registro creado: $fecha');
  }

  // Generar fechas intermedias
  List<String> _generarFechasIntermedias(String desde, String hasta) {
    final dias = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    // Extraer fecha base de ambos strings
    DateTime parseFecha(String f) {
      final partes = f.split('-').last.split('/');
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      return DateTime(2025, mes, dia); // AÃ±o arbitrario
    }

    final inicio = parseFecha(desde);
    final fin = parseFecha(hasta);

    final fechas = <String>[];
    DateTime actual = inicio.add(Duration(days: 1));

    while (actual.isBefore(fin)) {
      String inicialDia = dias[actual.weekday - 1];
      String fechaFormateada =
          "$inicialDia-${actual.day.toString().padLeft(2, '0')}/${actual.month.toString().padLeft(2, '0')}";
      fechas.add(fechaFormateada);
      actual = actual.add(Duration(days: 1));
    }

    return fechas;
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

  // Mostrar estadÃ­sticas
  void mostrarEstadisticas() {
    print('\n=== ESTADÃSTICAS ===');
    print('Total de registros: ${_box.length}');

    const encabezado = ['Fecha', 'Total(ms)', 'Ãšltimo(ms)', 'Llamadas'];

    final separator = '+' + List.filled(5, '-' * 15).join('+') + '+';

    // Encabezado
    print(separator);
    print(
      '| ' +
          encabezado[0].padRight(13) +
          ' | ' +
          encabezado[1].padRight(13) +
          ' | ' +
          encabezado[2].padRight(13) +
          ' | ' +
          encabezado[3].padRight(13) +
          ' | ',
    );
    print(separator);

    // Filas
    for (var record in _box.values) {
      print(
        '| ' +
            record.fecha.padRight(13) +
            ' | ' +
            record.timeMilis.toString().padLeft(13) +
            ' | ' +
            record.lastTimeMilis.toString().padLeft(13) +
            ' | ' +
            record.cont.toString().padLeft(13) +
            ' |',
      );
    }

    print(separator);
  }

  // MÃ©todo para inicializar la semilla
  Future<void> seedData() async {
    if (_box.isEmpty) {
      await _box.addAll([
        TimeRecord(
          fecha: 'D-22/06',
          timeMilis: 700000,
          lastTimeMilis: 700000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'L-23/06',
          timeMilis: 800000,
          lastTimeMilis: 800000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'M-24/06',
          timeMilis: 900000,
          lastTimeMilis: 900000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'X-25/06',
          timeMilis: 100000,
          lastTimeMilis: 100000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'J-26/06',
          timeMilis: 110000,
          lastTimeMilis: 110000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'V-27/06',
          timeMilis: 120000,
          lastTimeMilis: 120000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'S-28/06',
          timeMilis: 130000,
          lastTimeMilis: 130000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'D-29/06',
          timeMilis: 140000,
          lastTimeMilis: 140000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'L-30/06',
          timeMilis: 100000,
          lastTimeMilis: 100000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'M-01/07',
          timeMilis: 100000,
          lastTimeMilis: 100000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'X-02/07',
          timeMilis: 170000,
          lastTimeMilis: 170000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'J-03/07',
          timeMilis: 100000,
          lastTimeMilis: 100000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'V-04/07',
          timeMilis: 900000,
          lastTimeMilis: 900000,
          cont: 1,
        ),
        TimeRecord(
          fecha: 'S-05/07',
          timeMilis: 200000,
          lastTimeMilis: 200000,
          cont: 1,
        ),
      ]);
      print('âœ… Datos semilla insertados');
    } else {
      print('â„¹ï¸ La caja ya tiene datos');
    }
  }
}

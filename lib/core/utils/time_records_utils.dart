import 'package:app_proyect/models/semana_data.dart';
import 'package:app_proyect/models/time_record.dart';
import 'package:intl/intl.dart';

class TimeRecordsUtils {
  static DateTime _parsearFecha(String fecha) {
    String fechaSinDia = fecha.substring(2);
    int year = 2024;
    List<String> partes = fechaSinDia.split('/');
    int dia = int.parse(partes[0]);
    int mes = int.parse(partes[1]);
    return DateTime(year, mes, dia);
  }

  static String _obtenerClaveSemanaa(DateTime fecha) {
    DateTime lunes = fecha.subtract(Duration(days: fecha.weekday - 1));
    return DateFormat('yyyy-MM-dd').format(lunes);
  }

  static Map<String, SemanaData> agruparRegistrosPorSemana(
    List<TimeRecord> registros,
  ) {
    if (registros.isEmpty) return {};
    registros.sort(
      (a, b) => _parsearFecha(a.fecha).compareTo(_parsearFecha(b.fecha)),
    );
    Map<String, List<TimeRecord>> semanas = {};
    for (var registro in registros) {
      DateTime fecha = _parsearFecha(registro.fecha);
      String clave = _obtenerClaveSemanaa(fecha);
      semanas.putIfAbsent(clave, () => []).add(registro);
    }

    Map<String, SemanaData> resultado = {};
    semanas.forEach((clave, registrosSemana) {
      int totalTimeMilis = registrosSemana.fold(
        0,
        (sum, record) => sum + record.timeMilis,
      );
      int totalCont = registrosSemana.fold(
        0,
        (sum, record) => sum + record.cont,
      );
      DateTime inicioSemana = _parsearFecha(registrosSemana.first.fecha)
          .subtract(
            Duration(
              days: _parsearFecha(registrosSemana.first.fecha).weekday - 1,
            ),
          );
      DateTime finSemana = inicioSemana.add(Duration(days: 6));
      String rango =
          '${DateFormat('dd/MM').format(inicioSemana)} - ${DateFormat('dd/MM').format(finSemana)}';
      resultado[clave] = SemanaData(
        rango: rango,
        registros: registrosSemana,
        totalTimeMilis: totalTimeMilis,
        totalCont: totalCont,
      );
    });
    return resultado;
  }

  static List<SemanaData> agruparRegistrosPorSemanaLista(
    List<TimeRecord> registros,
  ) {
    Map<String, SemanaData> mapaResultado = agruparRegistrosPorSemana(
      registros,
    );
    List<SemanaData> listaOrdenada = mapaResultado.values.toList();
    listaOrdenada.sort((a, b) {
      DateTime fechaA = DateFormat('dd/MM').parse(a.rango.split(' - ')[0]);
      DateTime fechaB = DateFormat('dd/MM').parse(b.rango.split(' - ')[0]);
      return fechaA.compareTo(fechaB);
    });
    return listaOrdenada;
  }

  static List<TimeRecord> obtenerRegistrosPorIndice(
    List<TimeRecord> registros,
    int indiceSemana,
  ) {
    final semanas = agruparRegistrosPorSemanaLista(registros);
    if (indiceSemana < 0 || indiceSemana >= semanas.length) return [];
    return semanas[indiceSemana].registros;
  }
}

import 'package:app_proyect/models/time_record.dart';

class SemanaData {
  final String rango;
  final List<TimeRecord> registros;
  final int totalTimeMilis;
  final int totalCont;

  SemanaData({
    required this.rango,
    required this.registros,
    required this.totalTimeMilis,
    required this.totalCont,
  });
}

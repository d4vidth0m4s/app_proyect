import 'package:hive/hive.dart';

part 'time_record.g.dart';

// Modelo de datos para Hive
@HiveType(typeId: 0)
class TimeRecord extends HiveObject {
  @HiveField(0)
  String fecha; // Formato: "DD/MM"
  
  @HiveField(1)
  int timeMilis;
  
  @HiveField(2)
  int cont;
  
  TimeRecord({
    required this.fecha,
    required this.timeMilis,
    required this.cont,
  });
  
  @override
  String toString() {
    return 'TimeRecord{fecha: $fecha, timeMilis: $timeMilis, cont: $cont}';
  }
}
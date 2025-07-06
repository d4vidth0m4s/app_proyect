// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeRecordAdapter extends TypeAdapter<TimeRecord> {
  @override
  final int typeId = 0;

  @override
  TimeRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeRecord(
      fecha: fields[0] as String,
      timeMilis: fields[1] as int,
      cont: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimeRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.fecha)
      ..writeByte(1)
      ..write(obj.timeMilis)
      ..writeByte(2)
      ..write(obj.cont);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

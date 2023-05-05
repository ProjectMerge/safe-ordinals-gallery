// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyDataAdapter extends TypeAdapter<MyData> {
  @override
  final int typeId = 0;

  @override
  MyData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyData(
      name: fields[1] as String,
      base64: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MyData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.base64)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

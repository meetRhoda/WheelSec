// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unique_code.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UniqueCodeAdapter extends TypeAdapter<UniqueCode> {
  @override
  final int typeId = 2;

  @override
  UniqueCode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UniqueCode(
      branch: fields[0] as String,
      address: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UniqueCode obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.branch)
      ..writeByte(1)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UniqueCodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

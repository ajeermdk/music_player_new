// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongsDBAdapter extends TypeAdapter<SongsDB> {
  @override
  final int typeId = 1;

  @override
  SongsDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SongsDB(
      title: fields[0] as String?,
      artist: fields[1] as String?,
      duration: fields[2] as String?,
      id: fields[3] as String?,
      image: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SongsDB obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongsDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

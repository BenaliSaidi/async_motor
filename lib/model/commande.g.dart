// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commande.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComndAdapter extends TypeAdapter<Comnd> {
  @override
  final int typeId = 2;

  @override
  Comnd read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comnd(
      fields[1] as double,
      fields[2] as double,
      fields[3] as double,
      fields[4] as int,
      fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Comnd obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.frequence)
      ..writeByte(2)
      ..write(obj.tensionMax)
      ..writeByte(3)
      ..write(obj.tmpDeCycle)
      ..writeByte(4)
      ..write(obj.vitesse)
      ..writeByte(5)
      ..write(obj.nbrDeCommande);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComndAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

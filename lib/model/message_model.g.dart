// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 222;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      sId: fields[8] as String?,
      text: fields[9] as String?,
      conversation: fields[10] as String?,
      sender: fields[11] as String?,
      material: fields[12] as String?,
      iV: fields[13] as int?,
      createdAt: fields[14] as String?,
      updatedAt: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(8)
      ..write(obj.sId)
      ..writeByte(9)
      ..write(obj.text)
      ..writeByte(10)
      ..write(obj.conversation)
      ..writeByte(11)
      ..write(obj.sender)
      ..writeByte(12)
      ..write(obj.material)
      ..writeByte(13)
      ..write(obj.iV)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

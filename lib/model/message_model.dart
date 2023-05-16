import 'package:hive/hive.dart';
part 'message_model.g.dart';

@HiveType(typeId: 2)
class MessageModel {
  @HiveField(8)
  String? sId;
  @HiveField(9)
  String? text;
  @HiveField(10)
  String? conversation;
  @HiveField(11)
  String? sender;
  @HiveField(12)
  String? material;
  @HiveField(13)
  int? iV;
  @HiveField(14)
  String? createdAt;
  @HiveField(15)
  String? updatedAt;

  MessageModel(
      {this.sId,
      this.text,
      this.conversation,
      this.sender,
      this.material,
      this.iV,
      this.createdAt,
      this.updatedAt});

  MessageModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    text = json['text'];
    conversation = json['conversation'];
    sender = json['sender'];
    material = json['material'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['text'] = text;
    data['conversation'] = conversation;
    data['sender'] = sender;
    data['material'] = material;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

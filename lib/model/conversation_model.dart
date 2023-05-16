import 'package:hive/hive.dart';
part 'conversation_model.g.dart';

@HiveType(typeId: 1)
class ConversationModel {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? title;
  @HiveField(2)
  List<String>? participants;
  @HiveField(3)
  String? image;
  @HiveField(4)
  String? lastMessage;
  @HiveField(5)
  String? createdAt;
  @HiveField(6)
  String? updatedAt;
  @HiveField(7)
  int? iV;

  ConversationModel(
      {this.sId,
      this.title,
      this.participants,
      this.image,
      this.lastMessage,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    participants = json['participants'].cast<String>();
    image = json['image'];
    lastMessage = json['lastMessage'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['participants'] = participants;
    data['image'] = image;
    data['lastMessage'] = lastMessage;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

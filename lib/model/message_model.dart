class MessageModel {
  String? sId;
  String? text;
  String? conversation;
  String? sender;
  String? material;
  int? iV;
  String? createdAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['text'] = this.text;
    data['conversation'] = this.conversation;
    data['sender'] = this.sender;
    data['material'] = this.material;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ConversationModel {
  String? sId;
  String? title;
  List<String>? participants;
  String? image;
  String? lastMessage;
  String? createdAt;
  String? updatedAt;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['participants'] = this.participants;
    data['image'] = this.image;
    data['lastMessage'] = this.lastMessage;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

import 'dart:developer';

import 'package:dailydoc/main.dart';
import 'package:dio/dio.dart';

import '../../model/message_model.dart';

import 'api/api.dart';

class MessageRepository {
  API api = API();

  Future fetchMessage(
    String conversationId,
    String nextCurser,
  ) async {
    try {
      Response response =
          await api.sendReq.get('/$conversationId/messages', queryParameters: {
        'nextCurser': nextCurser,
      });
      List<dynamic> messageMaps = response.data['data']['messages'];

      List<MessageModel> newMessageMaps = [];

      for (int i = 0; i < messageMaps.length; i++) {
        newMessageMaps.add(
          MessageModel(
            sId: messageMaps[i]['_id'],
            text: messageMaps[i]['text'],
            conversation: messageMaps[i]['conversation'],
            sender: messageMaps[i]['sender'],
            material: messageMaps[i]['material'],
            iV: messageMaps[i]['__v'],
            createdAt: messageMaps[i]['createdAt'],
            updatedAt: messageMaps[i]['updatedAt'],
          ),
        );
      }
      box.put('messageMaps', newMessageMaps);

      return messageMaps
          .map((messageMap) => MessageModel.fromJson(messageMap))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  void sendMessage(
    String message,
    String conversationId,
    String sender,
  ) async {
    try {
      Response response =
          await api.sendReq.post('/$conversationId/messages', data: {
        'text': message,
        'sender': sender,
      });
      log('Resp == ${response.data}');
    } catch (e) {
      rethrow;
    }
  }
}

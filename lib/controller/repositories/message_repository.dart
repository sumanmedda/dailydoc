import 'dart:developer';

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

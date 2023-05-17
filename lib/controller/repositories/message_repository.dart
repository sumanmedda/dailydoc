import 'dart:developer';

import 'package:dio/dio.dart';

import '../../model/message_model.dart';

import '../const.dart';
import 'api/api.dart';

class MessageRepository {
  API api = API();

  Future fetchMessage(
    String conversationId,
    String nextCurser,
    bool firstFetch,
  ) async {
    try {
      Response response =
          await api.sendReq.get('/$conversationId/messages', queryParameters: {
        'nextCurser': nextCurser,
      });
      List<dynamic> messageMaps = response.data['data']['messages'];
      localDb.put('nextCursor', response.data['data']['nextCurser']);
      List<MessageModel>? oldMessageMaps = [];
      List<MessageModel>? newMessageMaps = [];

      for (int i = 0; i < messageMaps.length; i++) {
        firstFetch
            ? oldMessageMaps.add(
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
              )
            : newMessageMaps.add(
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

      if (firstFetch) {
        localDb.put('messageMaps', oldMessageMaps);
      } else {
        List<MessageModel> finalMsgList = List.from(localDb.get('messageMaps'))
          ..addAll(newMessageMaps);
        localDb.put('messageMaps', finalMsgList);
      }

      // oldMessageMaps.addAll(localDb.get('messageMaps') ?? '');
      // newMessageMaps.addAll(localDb.get('messageMaps'));
      // firstFetch
      //     ? localDb.put('messageMaps', oldMessageMaps)
      //     : localDb.put('messageMaps', newMessageMaps);

      log('message as 1${localDb.get('messageMaps')}');
      log('message as 2$oldMessageMaps');
      log('message as 3$newMessageMaps');

      return messageMaps
          .map((messageMap) => MessageModel.fromJson(messageMap))
          .toList();

      // return messageMaps
      //     .map((messageMap) => MessageModel.fromJson(messageMap))
      //     .toList();
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

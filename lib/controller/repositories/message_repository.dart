import 'dart:developer';

import 'package:dio/dio.dart';

import '../../main.dart';
import '../../model/message_model.dart';

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
      box.put('nextCursor', response.data['data']['nextCurser']);
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

      ///

      List<dynamic> convList = List.from(box.get('convList'))
        ..add(conversationId);

      box.put('convList', convList);

      log('message List === ${box.get('convList')}');

      ///

      if (firstFetch) {
        box.put('messageMaps', oldMessageMaps);
        box.put('localList', {conversationId: box.get('messageMaps')});
      } else {
        List<MessageModel> finalMsgList = List.from(box.get('messageMaps'))
          ..addAll(newMessageMaps);
        box.put('messageMaps', finalMsgList);

        box.put('localList', {conversationId: box.get('messageMaps')});
      }

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
      // ignore: unused_local_variable
      Response response =
          await api.sendReq.post('/$conversationId/messages', data: {
        'text': message,
        'sender':
            sender, // taken sender as 1st element of participants from conversation list as new user is not registered so dont have the unique id
      });
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:dailydoc/model/conversation_model.dart';
import 'package:dio/dio.dart';

import '../../main.dart';

import 'api/api.dart';

class ConversationRepository {
  API api = API();

  Future fetchConversation() async {
    try {
      Response response = await api.sendReq.get(
          '/'); // json data fetched from api will be stored in response variable

      List<dynamic> conversationMaps = response
          .data['data']; // conversationMaps will store conversation list data
      List<ConversationModel> localDbConversationMaps =
          []; // for storing data in local database localDbConversationMaps of type ConversationModel is used.

      for (int i = 0; i < conversationMaps.length; i++) {
        localDbConversationMaps.add(
          ConversationModel(
            sId: conversationMaps[i]['_id'],
            title: conversationMaps[i]['title'],
            participants: conversationMaps[i]['participants'].cast<String>(),
            image: conversationMaps[i]['image'],
            lastMessage: conversationMaps[i]['lastMessage'],
            createdAt: conversationMaps[i]['createdAt'],
            updatedAt: conversationMaps[i]['updatedAt'],
            iV: conversationMaps[i]['__v'],
          ),
        );
      }

      box.put('conversationMaps',
          localDbConversationMaps); // data is inserted into local db

      return conversationMaps
          .map((conversationMap) => ConversationModel.fromJson(conversationMap))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:dailydoc/model/conversation_model.dart';
import 'package:dio/dio.dart';

import '../const.dart';
import 'api/api.dart';

class ConversationRepository {
  API api = API();

  Future fetchConversation() async {
    try {
      Response response = await api.sendReq.get('/');

      List<dynamic> conversationMaps = response.data['data'];
      List<ConversationModel> newConversationMaps = [];

      for (int i = 0; i < conversationMaps.length; i++) {
        newConversationMaps.add(
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
      localDb.put('conversationMaps', newConversationMaps);
      return conversationMaps
          .map((conversationMap) => ConversationModel.fromJson(conversationMap))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

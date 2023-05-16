import 'package:dailydoc/controller/const.dart';
import 'package:dailydoc/model/conversation_model.dart';
import 'package:dio/dio.dart';

import 'api/api.dart';

class ConversationRepository {
  API api = API();

  Future fetchConversation() async {
    try {
      Response response = await api.sendReq.get('/');
      List<dynamic> conversationMaps = response.data;
      if (localDb.get('conversationMaps') == null) {
        // Add Local Storage Data
      } else {
        return conversationMaps
            .map((conversationMap) =>
                ConversationModel.fromJson(conversationMap))
            .toList();
      }
    } catch (e) {
      rethrow;
    }
  }
}

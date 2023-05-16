import 'package:dio/dio.dart';

import '../../model/message_model.dart';
import '../const.dart';
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
      List<dynamic> messageMaps = response.data;
      if (localDb.get('messageMaps') == null) {
        // Add Local Storage Data
      } else {
        return messageMaps
            .map((messageMap) => MessageModel.fromJson(messageMap))
            .toList();
      }
    } catch (e) {
      rethrow;
    }
  }
}

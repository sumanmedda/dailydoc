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
      List<dynamic> messageMaps = response.data['data']['messages'];
      if (localDb.get('messageMaps') == null) {
        return messageMaps
            .map((messageMap) => MessageModel.fromJson(messageMap))
            .toList();
      } else {}
    } catch (e) {
      rethrow;
    }
  }
}

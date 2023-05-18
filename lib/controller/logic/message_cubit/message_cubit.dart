import 'package:dailydoc/controller/repositories/message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../main.dart';

import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  var conversationId = box.get('conversationId') ?? '';
  var nextCurser = box.get('nextCurser') ?? '';
  var firstFetch = box.get('firstFetch') ?? '';

  MessageCubit() : super(MessageLoadingState()) {
    fetchMessages(conversationId, nextCurser, firstFetch);
  }

  MessageRepository messageRepository = MessageRepository();

  void fetchMessages(conversationId, nextCurser, firstFetch) async {
    try {
      List<dynamic> messages = await messageRepository.fetchMessage(
          conversationId, nextCurser, firstFetch);
      emit(MessageLoadedState(messages));
    } catch (e) {
      emit(MessageErrorState(e.toString()));
    }
  }

  void sendMessage(message, conversationId, sender) {
    messageRepository.sendMessage(message, conversationId, sender);
  }
}

import 'package:dailydoc/controller/repositories/message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../main.dart';

import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  // to take the initial values
  var conversationId = box.get('conversationId') ?? '';
  var nextCurser = box.get('nextCurser') ?? '';
  var firstFetch = box.get('firstFetch') ?? '';

  MessageCubit() : super(MessageLoadingState()) {
    // While loading messages list fetchMessages is used for fetching data using fetchConversations function
    fetchMessages(conversationId, nextCurser, firstFetch);
  }

  // messageRepository is used to import the fetchMessage function
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

  // this function is used to post messages
  sendMessage(message, conversationId, sender) {
    try {
      messageRepository.sendMessage(message, conversationId, sender);
    } catch (e) {
      return MessageErrorState(e.toString());
    }
  }
}

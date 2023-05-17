import 'package:dailydoc/controller/const.dart';
import 'package:dailydoc/controller/repositories/message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  var conversationId = localDb.get('conversationId') ?? '';
  var nextCurser = localDb.get('nextCurser') ?? '';

  MessageCubit() : super(MessageLoadingState()) {
    fetchMessages(conversationId, nextCurser);
  }

  MessageRepository messageRepository = MessageRepository();

  void fetchMessages(conversationId, nextCurser) async {
    try {
      List<dynamic> messages =
          await messageRepository.fetchMessage(conversationId, nextCurser);
      emit(MessageLoadedState(messages));
    } catch (e) {
      emit(MessageErrorState(e.toString()));
    }
  }

  void sendMessage(message, conversationId, sender) {
    messageRepository.sendMessage(message, conversationId, sender);
  }
}

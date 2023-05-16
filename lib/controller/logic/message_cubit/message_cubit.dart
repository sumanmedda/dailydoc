import 'package:dailydoc/controller/repositories/message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageLoadingState());

  MessageRepository messageRepository = MessageRepository();

  void fetchMessages() async {
    try {
      List<dynamic> messages = await messageRepository.fetchMessage(
        '',
        '',
      );
      emit(MessageLoadedState(messages));
    } catch (e) {
      emit(MessageErrorState(e.toString()));
    }
  }
}

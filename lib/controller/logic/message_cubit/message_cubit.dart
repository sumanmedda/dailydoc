import 'package:dailydoc/controller/repositories/message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageLoadingState()) {
    fetchMessages();
  }

  MessageRepository messageRepository = MessageRepository();

  void fetchMessages() async {
    try {
      List<dynamic> messages = await messageRepository.fetchMessage(
        '63f5c489f32cc275764a7e15',
        '63f5c6a1388472775c0626cd',
      );
      emit(MessageLoadedState(messages));
    } catch (e) {
      emit(MessageErrorState(e.toString()));
    }
  }
}

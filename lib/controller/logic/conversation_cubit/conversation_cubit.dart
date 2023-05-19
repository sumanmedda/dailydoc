import 'package:dailydoc/controller/logic/conversation_cubit/conversation_state.dart';
import 'package:dailydoc/controller/repositories/convesation_repository.dart';
import 'package:dailydoc/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit() : super(ConversationLoadingState()) {
    fetchConversations();
  }

  ConversationRepository conversationRepository = ConversationRepository();

  void fetchConversations() async {
    try {
      if (box.get('conversationMaps') == null) {
        List<dynamic> conversations =
            await conversationRepository.fetchConversation();
        emit(ConversationLoadedState(conversations));
      } else {
        List<dynamic> conversations = box.get('conversationMaps');
        emit(ConversationLoadedState(conversations));
      }
    } catch (e) {
      emit(ConversationErrorState(e.toString()));
    }
  }
}

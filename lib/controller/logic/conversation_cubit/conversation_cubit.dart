import 'package:dailydoc/controller/logic/conversation_cubit/conversation_state.dart';
import 'package:dailydoc/controller/repositories/convesation_repository.dart';
import 'package:dailydoc/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// This is used for bloc state management of conversation list
class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit() : super(ConversationLoadingState()) {
    // While loading conversation list is fetched using fetchConversations function
    fetchConversations();
  }

  // conversationRepository is used to get the fetchConversations function
  ConversationRepository conversationRepository = ConversationRepository();

  // fetchConversations emits the states on particular events occured
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

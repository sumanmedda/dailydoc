import 'package:dailydoc/controller/logic/conversation_cubit/conversation_state.dart';
import 'package:dailydoc/controller/repositories/convesation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit() : super(ConversationLoadingState());

  ConversationRepository conversationRepository = ConversationRepository();

  void fetchConversations() async {
    try {
      List<dynamic> conversations =
          await conversationRepository.fetchConversation();
      emit(ConversationLoadedState(conversations));
    } catch (e) {
      emit(ConversationErrorState(e.toString()));
    }
  }
}

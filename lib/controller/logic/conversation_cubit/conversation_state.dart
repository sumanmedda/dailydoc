abstract class ConversationState {}

class ConversationLoadingState extends ConversationState {}

class ConversationLoadedState extends ConversationState {
  final List<dynamic> conversations;
  ConversationLoadedState(this.conversations);
}

class ConversationErrorState extends ConversationState {
  final String error;
  ConversationErrorState(this.error);
}

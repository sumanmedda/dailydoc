abstract class MessageState {}

class MessageLoadingState extends MessageState {
  MessageLoadingState();
}

class MessageLoadedState extends MessageState {
  final List<dynamic> messages;
  MessageLoadedState(this.messages);
}

class MessageErrorState extends MessageState {
  final String error;
  MessageErrorState(this.error);
}

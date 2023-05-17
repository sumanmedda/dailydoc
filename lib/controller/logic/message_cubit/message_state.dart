abstract class MessageState {}

class MessageLoadingState extends MessageState {
  MessageLoadingState();
}

class MessageLoadedState extends MessageState {
  final List<dynamic> messages;
  MessageLoadedState(this.messages);
}

class MessageOldLoadedState extends MessageState {
  final List<dynamic> oldMessages;
  final bool isFirstFetched;
  MessageOldLoadedState(this.oldMessages, {this.isFirstFetched = false});
}

class MessageErrorState extends MessageState {
  final String error;
  MessageErrorState(this.error);
}

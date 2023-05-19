abstract class MessageState {}

// when a messagecubit event is triggered paticular states are called
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

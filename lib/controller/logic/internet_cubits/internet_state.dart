abstract class InternetState {}

class InternetLoadingState extends InternetState {}

class InternetGainedState extends InternetState {
  final List<dynamic> conversations;
  InternetGainedState(
    this.conversations,
  );
}

class InternetLostState extends InternetState {
  final String error;

  InternetLostState(
    this.error,
  );
}

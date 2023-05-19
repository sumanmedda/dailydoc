abstract class InternetState {}

class InternetLoadingState extends InternetState {}

class InternetGainedState extends InternetState {}

class InternetLostState extends InternetState {
  final String error;

  InternetLostState(
    this.error,
  );
}

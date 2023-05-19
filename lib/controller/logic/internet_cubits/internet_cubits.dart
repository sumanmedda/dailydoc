import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  // _connectivity is the package used to get infromation about internet
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  InternetCubit() : super(InternetLoadingState()) {
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // if internet is connected InternetGainedState is emited
        emit(InternetGainedState());
      } else {
        // if internet is not connected InternetLostState is emited
        emit(InternetLostState('Not Connected To Internet'));
      }
    });
  }

  // used to close the connectivitySubscription
  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}

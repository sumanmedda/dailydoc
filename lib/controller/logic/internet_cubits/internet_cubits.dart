import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/convesation_repository.dart';
import 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  // _connectivity is the package used to get infromation about internet
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;
  // conversationRepository is used to get the fetchConversations function
  ConversationRepository conversationRepository = ConversationRepository();

  InternetCubit() : super(InternetLoadingState()) {
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        // if internet is connected InternetGainedState is emited
        List<dynamic> conversations =
            await conversationRepository.fetchConversation();
        emit(InternetGainedState(conversations));
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

import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/convesation_repository.dart';

import 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  InternetCubit() : super(InternetLoadingState()) {
    ConversationRepository conversationRepository = ConversationRepository();
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        List<dynamic> conversations =
            await conversationRepository.fetchConversation();
        emit(InternetGainedState(conversations));
      } else {
        List<dynamic> conversations =
            await conversationRepository.fetchConversation();
        emit(InternetLostState('Not Connected To Internet', conversations));
      }
    });
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}

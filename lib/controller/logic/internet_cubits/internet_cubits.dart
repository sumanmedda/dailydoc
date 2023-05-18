import 'dart:async';
import 'dart:developer';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main.dart';
import '../../repositories/convesation_repository.dart';

import '../../repositories/message_repository.dart';
import 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;
  ConversationRepository conversationRepository = ConversationRepository();
  MessageRepository messageRepository = MessageRepository();
  var conversationId = box.get('conversationId') ?? '';
  var nextCurser = box.get('nextCurser') ?? '';

  InternetCubit() : super(InternetLoadingState()) {
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) async {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        log('Conn == $result');
        List<dynamic> conversations =
            await conversationRepository.fetchConversation();
        List<dynamic> messages = await messageRepository.fetchMessage(
            conversationId, nextCurser, true);
        log('Conn == yes');
        emit(InternetGainedState(conversations, messages));
      } else {
        log('Conn == No');

        // List<dynamic> messages = await messageRepository.fetchMessage(
        //     conversationId, nextCurser, false);

        emit(InternetLostState('Not Connected To Internet'));
      }
    });
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}

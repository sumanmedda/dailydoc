import 'package:dailydoc/controller/const.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_cubit.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_state.dart';
import 'package:dailydoc/controller/logic/internet_cubits/internet_cubits.dart';
import 'package:dailydoc/controller/logic/internet_cubits/internet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, internetState) =>
              BlocBuilder<ConversationCubit, ConversationState>(
                  builder: (context, conversationState) {
            // When data is loading
            if (conversationState is ConversationLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // When data is loaded
            if (conversationState is ConversationLoadedState) {
              return conversationListView(conversationState.conversations);
            }
            // When There is no internet occours
            if (conversationState is ConversationErrorState) {
              // When internet is not connected
              if (internetState is InternetLostState) {
                return conversationListView(internetState.conversations);
              }
              // When internet is connected
              if (internetState is InternetGainedState) {
                return conversationListView(internetState.conversations);
              }
            }

            // If Something went Wrong / No Data
            return const Center(
              child: Text('No Data Found'),
            );
          }),
        ),
      ),
    );
  }
}

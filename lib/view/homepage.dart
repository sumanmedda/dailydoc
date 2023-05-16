import 'package:dailydoc/controller/logic/conversation_cubit/conversation_cubit.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_state.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_cubit.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_state.dart';
import 'package:dailydoc/controller/logic/message_cubit/message_cubit.dart';
import 'package:dailydoc/controller/logic/message_cubit/message_state.dart';
import 'package:dailydoc/model/conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, internetState) =>
            BlocBuilder<ConversationCubit, ConversationState>(
                builder: (context, conversationState) {
          // If No Internet
          if (internetState is InternetLostState) {
            return const Center(
              child: Text('No Internet Connectivity'),
            );
          }
          // If Internet if Present
          if (internetState is InternetGainedState) {
            // When in loading state
            if (conversationState is ConversationLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // When in loading state is done and its loaded state
            if (conversationState is ConversationLoadedState) {
              return ListView.builder(
                  itemCount: conversationState.conversations.length,
                  itemBuilder: (context, index) {
                    ConversationModel path =
                        conversationState.conversations[index];
                    return ListTile(
                      title: Text(path.title.toString()),
                    );
                  });
            }
            // When in there is some error in data
            if (conversationState is ConversationErrorState) {
              return Center(
                child: Text(
                  conversationState.error.toString(),
                  textAlign: TextAlign.center,
                ),
              );
            }
          }
          // If Something went Wrong
          return const Center(
            child: Text('An Error Occured'),
          );
        }),
      ),
    );
  }
}

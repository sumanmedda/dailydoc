import 'package:dailydoc/controller/const.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_cubit.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ConversationCubit, ConversationState>(
            builder: (context, conversationState) {
          if (conversationState is ConversationLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (conversationState is ConversationLoadedState) {
            return conversationListView(conversationState.conversations);
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

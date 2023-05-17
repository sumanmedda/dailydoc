import 'package:dailydoc/controller/const.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_cubit.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_state.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_cubit.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<InternetCubit, InternetState>(
          listener: (context, internetState) {
            if (internetState is InternetLostState) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Internet Not Connected'),
                backgroundColor: Colors.red,
              ));
            }
            if (internetState is InternetGainedState) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Internet Connected'),
                backgroundColor: Colors.green,
              ));
            }
          },
          builder: (context, internetState) =>
              BlocBuilder<ConversationCubit, ConversationState>(
                  builder: (context, conversationState) {
            // If No Internet
            if (internetState is InternetLostState) {
              return conversationListView();
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
                return conversationListView();
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
      ),
    );
  }
}

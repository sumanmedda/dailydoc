import 'package:dailydoc/controller/const.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_cubit.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_state.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_cubit.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_state.dart';

import 'package:dailydoc/model/conversation_model.dart';
import 'package:dailydoc/view/message.dart';
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
                    physics: const BouncingScrollPhysics(),
                    itemCount: conversationState.conversations.length,
                    itemBuilder: (context, index) {
                      ConversationModel path =
                          conversationState.conversations[index];

                      return ListTile(
                        onTap: () {
                          nextPage(
                              context,
                              Message(
                                conversationId: path.sId.toString(),
                              ));
                        },
                        leading: CircleAvatar(
                          child: path.image!.isEmpty
                              ? const Icon(Icons.people)
                              : Image.network(path.image!),
                        ),
                        title: Text(path.title.toString()),
                        subtitle: Text(path.lastMessage.toString()),
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
      ),
    );
  }
}

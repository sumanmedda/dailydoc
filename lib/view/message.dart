import 'package:dailydoc/controller/logic/internet_cubit/internet_cubit.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_state.dart';
import 'package:dailydoc/controller/logic/message_cubit/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/logic/message_cubit/message_cubit.dart';
import '../model/message_model.dart';

class Message extends StatelessWidget {
  final String conversationId;
  const Message({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(conversationId),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, internetState) =>
              BlocBuilder<MessageCubit, MessageState>(
                  builder: (context, messageState) {
            // If No Internet
            if (internetState is InternetLostState) {
              return const Center(
                child: Text('No Internet Connectivity'),
              );
            }
            // If Internet if Present
            if (internetState is InternetGainedState) {
              // When in loading state
              if (messageState is MessageLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // When in loading state is done and its loaded state
              if (messageState is MessageLoadedState) {
                return ListView.builder(
                    itemCount: messageState.messages.length,
                    itemBuilder: (context, index) {
                      MessageModel path = messageState.messages[index];

                      return ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          child: path.material!.isEmpty
                              ? const Icon(Icons.people)
                              : Image.network(path.material!),
                        ),
                        title: Text(path.conversation.toString()),
                        subtitle: Text(path.sender.toString()),
                      );
                    });
              }
              // When in there is some error in data
              if (messageState is MessageErrorState) {
                return Center(
                  child: Text(
                    messageState.error.toString(),
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

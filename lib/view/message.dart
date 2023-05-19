import 'package:dailydoc/controller/logic/message_cubit/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/const.dart';
import '../controller/logic/internet_cubits/internet_cubits.dart';
import '../controller/logic/internet_cubits/internet_state.dart';
import '../controller/logic/message_cubit/message_cubit.dart';
import '../main.dart';

class Message extends StatelessWidget {
  final String conversationId;
  final String conversationTitle;
  final String participantsLength;
  final List participants;
  const Message({
    super.key,
    required this.conversationId,
    required this.conversationTitle,
    required this.participantsLength,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(conversationTitle),
            const SizedBox(
              height: 5,
            ),
            Text(
              '$participantsLength participants',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, internetState) =>
              BlocBuilder<MessageCubit, MessageState>(
                  builder: (context, messageState) {
            final size = MediaQuery.of(context).size;
            TextEditingController messageController = TextEditingController();
            final scrollController = ScrollController();

            // Scroll Listner for pagination
            if (internetState is InternetGainedState) {
              scrollController.addListener(() {
                if (scrollController.position.atEdge) {
                  // when bottom of screen is touched
                  if (scrollController.position.pixels != 0) {
                    return bottomHit(context);
                  }
                }
              });
            }

            // When Internet is connected
            if (internetState is InternetGainedState) {
              // When data is loading
              if (messageState is MessageLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // When data is loaded
              if (messageState is MessageLoadedState) {
                return messageListView(scrollController, size,
                    messageController, context, conversationId, participants);
              }

              //
              // If Error occurs in fetching messages
              if (messageState is MessageErrorState) {
                return Center(
                  child: Text(messageState.error),
                );
              }
            }

            // When Internet is not connected
            if (internetState is InternetLostState) {
              if (messageState is MessageLoadedState) {
                return messageListLostView(scrollController, size,
                    messageController, context, conversationId, participants);
              }
            }

            // To show local Data
            return messageListLostView(scrollController, size,
                messageController, context, conversationId, participants);
          }),
        ),
      ),
    );
  }

  void bottomHit(context) {
    // For pagination
    BlocProvider.of<MessageCubit>(context).fetchMessages(
      conversationId,
      box.get('nextCursor'),
      'No',
    );
  }
}

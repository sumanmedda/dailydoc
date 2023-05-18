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
                  if (scrollController.position.pixels != 0) {
                    return bottomHit(context);
                  }
                }
              });
            }

            // When data is loading
            if (messageState is MessageLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // When data is loaded
            if (messageState is MessageLoadedState) {
              if (internetState is InternetLostState) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: size.height - 100,
                    child: messageListLostView(
                      scrollController,
                      size,
                      messageController,
                      context,
                      conversationId,
                      participants,
                      true,
                    ),
                  ),
                );
              }
              if (internetState is InternetGainedState) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: size.height - 100,
                    child: messageListView(
                      scrollController,
                      size,
                      messageController,
                      context,
                      internetState.messages,
                      conversationId,
                      participants,
                      true,
                    ),
                  ),
                );
              }
            }

            // When There is no internet occours
            if (messageState is MessageErrorState) {
              // When internet is not connected
              if (internetState is InternetLostState) {
                return messageListLostView(
                  scrollController,
                  size,
                  messageController,
                  context,
                  conversationId,
                  participants,
                  true,
                );
              }
              // When internet is connected
              if (internetState is InternetGainedState) {
                return messageListView(
                  scrollController,
                  size,
                  messageController,
                  context,
                  internetState.messages,
                  conversationId,
                  participants,
                  true,
                );
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

  void bottomHit(context) {
    BlocProvider.of<MessageCubit>(context).fetchMessages(
      conversationId,
      box.get('nextCursor'),
      false,
    );
  }
}

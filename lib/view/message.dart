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
              final size = MediaQuery.of(context).size;
              TextEditingController messageController = TextEditingController();
              return SingleChildScrollView(
                child: SizedBox(
                  height: size.height - 100,
                  child: Column(
                    children: [
                      // Message List
                      Expanded(
                        flex: 20,
                        child: messageListView(
                            scrollController, messageState.messages),
                      ),
                      // Send Button
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: size.width * 0.7,
                                  child: TextField(
                                    controller: messageController,
                                    textAlign: TextAlign.start,
                                    decoration: const InputDecoration(
                                      hintText: "Send a Message",
                                    ),
                                  )),
                              IconButton(
                                onPressed: () {
                                  if (messageController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Please Enter Something'),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    BlocProvider.of<MessageCubit>(context)
                                        .sendMessage(
                                      messageController.text,
                                      conversationId,
                                      participants[0],
                                    );
                                    messageController.clear();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Message Sent'),
                                      backgroundColor: Colors.green,
                                    ));
                                  }
                                },
                                icon: const Icon(Icons.send),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            // When There is no internet occours
            if (messageState is MessageErrorState) {
              // When internet is not connected
              if (internetState is InternetLostState) {
                return messageListView(
                    scrollController, internetState.messages);
              }
              // When internet is connected
              if (internetState is InternetGainedState) {
                return messageListView(
                    scrollController, internetState.messages);
              }
            }

            // If Something went Wrong / No Data
            return const Center(
              child: Text('An Error Occured'),
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

import 'package:dailydoc/controller/logic/message_cubit/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/const.dart';
import '../controller/logic/message_cubit/message_cubit.dart';
import '../main.dart';
import '../model/message_model.dart';

class Message extends StatelessWidget {
  final String conversationId;
  final String conversationTitle;
  final String participants;
  const Message({
    super.key,
    required this.conversationId,
    required this.conversationTitle,
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
              '$participants participants',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<MessageCubit, MessageState>(
            builder: (context, messageState) {
          final scrollController = ScrollController();

          scrollController.addListener(() {
            if (scrollController.position.atEdge) {
              if (scrollController.position.pixels != 0) {
                bottomHit(context);
              }
            }
          });

          // When in loading state is doneW and its loaded state
          if (messageState is MessageLoadedState) {
            List<MessageModel> path = box.get('messageMaps') ?? '';
            final size = MediaQuery.of(context).size;
            TextEditingController messageController = TextEditingController();
            return SingleChildScrollView(
              child: SizedBox(
                height: size.height - 100,
                child: Column(
                  children: [
                    Expanded(
                      flex: 20,
                      child: messageListView(path, scrollController),
                    ),
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
                                BlocProvider.of<MessageCubit>(context)
                                    .sendMessage(
                                  messageController.text,
                                  conversationId,
                                  path[0].sender,
                                );
                                messageController.clear();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Message Sent'),
                                  backgroundColor: Colors.green,
                                ));
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
          // When in there is some error in data
          if (messageState is MessageErrorState) {
            return Center(
              child: Text(
                messageState.error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          }

          // If Something went Wrong
          return const Center(
            child: Text('An Error Occured'),
          );
        }),
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

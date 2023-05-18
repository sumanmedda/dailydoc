import 'dart:developer';

import 'package:dailydoc/controller/logic/internet_cubits/internet_cubits.dart';
import 'package:dailydoc/controller/logic/internet_cubits/internet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';

import '../view/message.dart';
import 'logic/message_cubit/message_cubit.dart';

nextPage(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

backPage(context) {
  Navigator.pop(context);
}

Column messageListView(
  ScrollController scrollController,
  Size size,
  TextEditingController messageController,
  BuildContext context,
  state,
  conversationId,
  participants,
  disableTextField,
) {
  List<dynamic> path = box.get('messageMaps');
  return Column(
    children: [
      // Message List
      Expanded(
        flex: 20,
        child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: path.length,
            itemBuilder: (context, index) {
              return Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.lightBlue[100],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(
                            path[index].text.toString(),
                          ),
                          SizedBox(
                            height: path[index].material == '' ? 0 : 10,
                          ),
                          path[index].material == ''
                              ? const SizedBox.shrink()
                              : SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Image.network(path[index].material!)),
                        ],
                      )),
                ),
              );
            }),
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
                    enabled: disableTextField,
                    controller: messageController,
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      hintText: "Send a Message",
                    ),
                  )),
              IconButton(
                onPressed: () {
                  if (messageController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please Enter Something'),
                      backgroundColor: Colors.red,
                    ));
                  } else {
                    BlocProvider.of<MessageCubit>(context).sendMessage(
                      messageController.text,
                      conversationId,
                      participants[0],
                    );
                    messageController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
  );
}

Column messageListLostView(
  ScrollController scrollController,
  Size size,
  TextEditingController messageController,
  BuildContext context,
  conversationId,
  participants,
  disableTextField,
) {
  Map<String, dynamic> list = box.get('localList');
  List<dynamic> path = list.values.first;

  return Column(
    children: [
      // Message List
      Expanded(
        flex: 20,
        child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: path.length,
            itemBuilder: (context, index) {
              return Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.lightBlue[100],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(
                            path[index].text.toString(),
                          ),
                          SizedBox(
                            height: path[index].material == '' ? 0 : 10,
                          ),
                          path[index].material == ''
                              ? const SizedBox.shrink()
                              : SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Image.network(path[index].material!)),
                        ],
                      )),
                ),
              );
            }),
      ),
    ],
  );
}

BlocBuilder conversationListView(state) {
  List<dynamic> path = state;
  return BlocBuilder<InternetCubit, InternetState>(
    builder: (context, internetState) {
      return Column(
        children: [
          Expanded(
            flex: 20,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: path.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      if (internetState is InternetLostState) {
                        nextPage(
                            context,
                            Message(
                              conversationId: path[index].sId.toString(),
                              conversationTitle: path[index].title.toString(),
                              participantsLength:
                                  path[index].participants!.length.toString(),
                              participants: path[index].participants!,
                            ));
                      } else {
                        box.put('conversationId', path[index].sId.toString());
                        BlocProvider.of<MessageCubit>(context).fetchMessages(
                            path[index].sId.toString(), '', true);
                        nextPage(
                            context,
                            Message(
                              conversationId: path[index].sId.toString(),
                              conversationTitle: path[index].title.toString(),
                              participantsLength:
                                  path[index].participants!.length.toString(),
                              participants: path[index].participants!,
                            ));
                      }
                    },
                    leading: CircleAvatar(
                      child: path[index].image!.isEmpty
                          ? const Icon(Icons.people)
                          : Image.network(path[index].image!),
                    ),
                    title: Text(path[index].title.toString()),
                    subtitle: Text(path[index].lastMessage.toString()),
                  );
                }),
          ),
        ],
      );
    },
  );
}

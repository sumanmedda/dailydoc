import 'package:dailydoc/controller/logic/internet_cubits/internet_cubits.dart';
import 'package:dailydoc/controller/logic/internet_cubits/internet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';

import '../view/message.dart';
import 'logic/message_cubit/message_cubit.dart';

// used for navigating to next page
nextPage(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

// used to navigate to previous page
backPage(context, value) {
  Navigator.pop(context, value);
}

// this when show local data when internet is connected
Column messageListView(
  ScrollController scrollController,
  Size size,
  TextEditingController messageController,
  BuildContext context,
  conversationId,
  participants,
) {
  List<dynamic> path = [];

  if (box.get(conversationId) != null) {
    path = box.get(conversationId);
  } else {
    path = [];
  }

  return Column(
    children: [
      // Message List
      Expanded(
        flex: 20,
        child: box.get(conversationId) == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
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
                                      child:
                                          Image.network(path[index].material!)),
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

// this when show local data when internet is not connected
Column messageListLostView(
  ScrollController scrollController,
  Size size,
  TextEditingController messageController,
  BuildContext context,
  conversationId,
  participants,
) {
  List<dynamic> path = [];

  if (box.get(conversationId) != null) {
    path = box.get(conversationId);
  } else {
    path = [];
  }

  return Column(
    children: [
      // Message List
      Expanded(
        flex: 20,
        child: box.get(conversationId) == null
            ? const Center(
                child: Text('No chat found'),
              )
            : ListView.builder(
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
                                      child:
                                          Image.network(path[index].material!)),
                            ],
                          )),
                    ),
                  );
                }),
      ),
    ],
  );
}

// this when show local data when internet is connected
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Message(
                                      conversationId:
                                          path[index].sId.toString(),
                                      conversationTitle:
                                          path[index].title.toString(),
                                      participantsLength: path[index]
                                          .participants!
                                          .length
                                          .toString(),
                                      participants: path[index].participants!,
                                    )));
                      } else {
                        box.put('conversationId', path[index].sId.toString());
                        BlocProvider.of<MessageCubit>(context)
                            .fetchMessages(path[index].sId.toString(), '', '');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Message(
                                      conversationId:
                                          path[index].sId.toString(),
                                      conversationTitle:
                                          path[index].title.toString(),
                                      participantsLength: path[index]
                                          .participants!
                                          .length
                                          .toString(),
                                      participants: path[index].participants!,
                                    )));
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

// this when show local data when internet is not connected
BlocBuilder conversationListLostView() {
  List<dynamic> path = box.get('conversationMaps');
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
                    onTap: () async {
                      if (internetState is InternetLostState) {
                        await nextPage(
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

                        await nextPage(
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

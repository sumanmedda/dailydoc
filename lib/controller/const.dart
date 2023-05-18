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

ListView messageListView(scrollController, state) {
  List<dynamic> path = state;
  return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: path.length,
      itemBuilder: (context, index) {
        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
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
      });
}

Column conversationListView(state) {
  List<dynamic> path = state;

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
                  box.put('conversationId', path[index].sId.toString());
                  BlocProvider.of<MessageCubit>(context)
                      .fetchMessages(path[index].sId.toString(), '', true);
                  nextPage(
                      context,
                      Message(
                        conversationId: path[index].sId.toString(),
                        conversationTitle: path[index].title.toString(),
                        participantsLength:
                            path[index].participants!.length.toString(),
                        participants: path[index].participants!,
                      ));
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
}

import 'package:dailydoc/controller/const.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_cubit.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_state.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_cubit.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_state.dart';

import 'package:dailydoc/model/conversation_model.dart';
import 'package:dailydoc/view/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/logic/message_cubit/message_cubit.dart';

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

  Column conversationListView() {
    List<ConversationModel> path = localDb.get('conversationMaps');
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
                    localDb.put('conversationId', path[index].sId.toString());
                    nextPage(
                        context,
                        Message(
                            conversationId: path[index].sId.toString(),
                            conversationTitle: path[index].title.toString(),
                            participants:
                                path[index].participants!.length.toString()));
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
}

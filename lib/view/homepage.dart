import 'package:dailydoc/controller/logic/conversation_cubit/conversation_cubit.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_state.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_cubit.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_state.dart';
import 'package:dailydoc/controller/logic/message_cubit/message_cubit.dart';
import 'package:dailydoc/controller/logic/message_cubit/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, internetState) =>
            BlocBuilder<ConversationCubit, ConversationState>(
                builder: (context, conversationState) {
          return Container();
        }),
      ),
    );
  }
}

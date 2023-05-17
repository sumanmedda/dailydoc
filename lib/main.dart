import 'package:dailydoc/controller/logic/conversation_cubit/conversation_cubit.dart';
import 'package:dailydoc/controller/logic/internet_cubit/internet_cubit.dart';
import 'package:dailydoc/controller/logic/message_cubit/message_cubit.dart';
import 'package:dailydoc/model/conversation_model.dart';
import 'package:dailydoc/model/message_model.dart';
import 'package:dailydoc/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('box');
  Hive.registerAdapter(ConversationModelAdapter());
  Hive.registerAdapter(MessageModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
          create: (context) => InternetCubit(),
        ),
        BlocProvider<ConversationCubit>(
          create: (context) => ConversationCubit(),
        ),
        BlocProvider<MessageCubit>(
          create: (context) => MessageCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Homepage(),
      ),
    );
  }
}

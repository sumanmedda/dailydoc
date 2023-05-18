import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:dailydoc/controller/logic/conversation_cubit/conversation_cubit.dart';

import 'package:dailydoc/controller/logic/message_cubit/message_cubit.dart';
import 'package:dailydoc/model/conversation_model.dart';
import 'package:dailydoc/model/message_model.dart';
import 'package:dailydoc/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box box;
Future<void> main() async {
  await Hive.initFlutter();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter<ConversationModel>(ConversationModelAdapter());
  Hive.registerAdapter(MessageModelAdapter());
  box = await Hive.openBox('box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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

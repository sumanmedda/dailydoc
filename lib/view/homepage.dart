import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyFirstBloc, MyFirstBlocState>(
      builder: (context, myFirstBlocState) =>
          BlocBuilder<MySecondBloc, MySecondBlocState>(
              builder: (context, secondBlocState) {
        return Container();
      }),
    );
  }
}

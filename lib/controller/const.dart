import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

var localDb = Hive.box('box');

nextPage(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

backPage(context) {
  Navigator.pop(context);
}

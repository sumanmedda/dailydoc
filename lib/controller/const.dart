import 'package:flutter/material.dart';

nextPage(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

backPage(context) {
  Navigator.pop(context);
}

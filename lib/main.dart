import 'package:flutter/material.dart';

import 'ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo List',
          home: Home(),
        );
      },
    );
  }
}

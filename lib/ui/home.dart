import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'todo_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      body: TodoScreen(),
    );
  }
}

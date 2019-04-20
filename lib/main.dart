import 'package:flutter/material.dart';

import './todo_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Todo app'),
        ),
        body: TodoManager(),
      ),
    );
  }
}

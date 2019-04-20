import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import './todo_list.dart';
import './todo_edit.dart';

class TodoManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoManagerState();
}

class _TodoManagerState extends State<TodoManager> {
  final FocusNode _newTodoFocusNode = FocusNode();
  final TextEditingController _newTodoController = TextEditingController();

  List<Map<String, String>> _todos = [];

  @override
  void dispose() {
    _newTodoController.dispose();
    super.dispose();
  }

  void _showTodoEmptyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Failed to create todo'),
          content: Text('Todo cannot be empty'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Okay'),
            )
          ],
        );
      },
    );
  }

  void _submitTodo() {
    if (_newTodoController.text == '') {
      _showTodoEmptyDialog();
      return;
    }

    setState(() {
      _todos.add({
        'id': Uuid().v4(),
        'title': _newTodoController.text,
      });
    });

    _newTodoController.text = '';
    _newTodoFocusNode.unfocus();
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((item) => item['id'] == id);
    });
  }

  void _updateTodo(String id) {
    final Map<String, String> todo =
        _todos.firstWhere((item) => item['id'] == id);

    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return TodoEdit(todo['title']);
      },
    ).then((value) {
      final int todoIndex = _todos.indexWhere((item) => item['id'] == id);

      setState(() {
        _todos[todoIndex] = {
          'id': Uuid().v4(),
          'title': value != null ? value : todo['title']
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              TextField(
                focusNode: _newTodoFocusNode,
                controller: _newTodoController,
                decoration: InputDecoration(labelText: 'New todo'),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                width: double.infinity,
                child: RaisedButton(
                  child: Text('Add todo'),
                  onPressed: _submitTodo,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: TodoList(_todos, _deleteTodo, _updateTodo),
        ),
      ],
    );
  }
}

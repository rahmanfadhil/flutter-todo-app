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

  Future<bool> _deleteTodo(String id) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this item?'),
          content: Text('This action cannot be undone!'),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.red,
              child: Text('Discard'),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text('Continue'),
              onPressed: () => Navigator.pop(context, true),
            )
          ],
        );
      },
    ).then((value) {
      if (value) {
        setState(() {
          _todos.removeWhere((item) => item['id'] == id);
        });
        return true;
      }
      return false;
    });
  }

  Future<bool> _updateTodo(String id) {
    final Map<String, String> todo =
        _todos.firstWhere((item) => item['id'] == id);

    return showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return TodoEdit(todo['title']);
      },
    ).then<bool>((value) {
      if (value != null) {
        final Map<String, String> todo =
            _todos.firstWhere((item) => item['id'] == id);
        setState(() {
          todo.update('title', (_) => value);
        });
      }
      return false;
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

import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  final List<Map<String, String>> todos;
  final Function deleteTodo;
  final Function updateTodo;

  TodoList(this.todos, this.deleteTodo, this.updateTodo);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        final Map<String, String> todo = todos[index];

        return Dismissible(
          key: Key(todo['id']),
          background: Container(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              padding: EdgeInsets.only(left: 15.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            color: Colors.red,
          ),
          secondaryBackground: Container(
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
            color: Colors.green,
          ),
          onDismissed: (DismissDirection direction) {
            if (DismissDirection.startToEnd == direction) {
              deleteTodo(todo['id']);
            } else if (DismissDirection.endToStart == direction) {
              updateTodo(todo['id']);
            }
          },
          child: ListTile(
            title: Text(todo['title']),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class TodoEdit extends StatefulWidget {
  final String title;

  TodoEdit(this.title);

  @override
  State<StatefulWidget> createState() {
    return _TodoEditState();
  }
}

class _TodoEditState extends State<TodoEdit> {
  TextEditingController _todoController;

  @override
  void initState() {
    _todoController = TextEditingController(text: widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _todoController,
            decoration: InputDecoration(labelText: 'Update todo'),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            width: double.infinity,
            child: RaisedButton(
              child: Text('Update todo'),
              onPressed: () {
                Navigator.pop(context, _todoController.text);
              },
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ToDoList(),
    theme: ThemeData(
      primarySwatch: Colors.orange,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<Map<String, dynamic>> _toDoList = [];
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[100],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('To-Do List'),backgroundColor: Colors.lightGreen,),
        body: ListView(children: _getItems()),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context, addTodoItem: _addTodoItem),
          tooltip: 'Add Item',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _addTodoItem(String title) {
    setState(() {
      _toDoList.add({"title": title, "done": false});
    });
    _textFieldController.clear();
  }

  void _updateTodoItem(Map<String, dynamic> item, String title) {
    setState(() {
      item["title"] = title;
    });
    _textFieldController.clear();
  }

  Widget _buildToDoItem(Map<String, dynamic> item) {
    return ListTile(
      title: Text(
        item["title"],
        style: item["done"]
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              )
            : null,
      ),
      trailing: Wrap(
        spacing: 12,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _displayDialog(context, 
                addTodoItem: (title) => _updateTodoItem(item, title),
                initialText: item["title"]),
          ),
          IconButton(
            icon: item["done"] ? Icon(Icons.undo, color: Colors.orange) : Icon(Icons.done, color: Colors.green),
            onPressed: () => _toggleDone(item),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteTodoItem(item),
          ),
        ],
      ),
    );
  }

  void _deleteTodoItem(Map<String, dynamic> item) {
    setState(() {
      _toDoList.remove(item);
    });
  }

  void _toggleDone(Map<String, dynamic> item) {
    setState(() {
      item["done"] = !item["done"];
    });
  }

  Future<Future> _displayDialog(BuildContext context, {required Function(String) addTodoItem, String initialText = ''}) async {
    _textFieldController.text = initialText;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('SAVE'),
                onPressed: () {
                  Navigator.of(context).pop();
                  addTodoItem(_textFieldController.text);
                },
              ),
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  List<Widget> _getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (Map<String, dynamic> item in _toDoList) {
      _todoWidgets.add(_buildToDoItem(item));
    }
    return _todoWidgets;
  }
}

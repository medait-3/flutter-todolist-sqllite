import 'package:flutter/material.dart';
import 'package:todo_application/model/todo_item.dart';
import 'package:todo_application/utils/database_client.dart';
import 'package:todo_application/utils/date_formattter.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController _textFieldController = new TextEditingController();
  var db = DatabaseHelper();
  final List<TodoItem> _itemsList = <TodoItem>[];

  @override
  void initState() {
    super.initState();
    _readTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          backgroundColor: Colors.black45,
          body: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                    itemCount: _itemsList.length,
                    itemBuilder: (_, int index) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: _itemsList[index],
                          onLongPress: () =>
                              _updateItem(_itemsList[index], index),
                          trailing: new Listener(
                            key: Key(_itemsList[index].itemName),
                            child: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPointerDown: (pointerEvent) =>
                                _handleDelete(_itemsList[index].id, index),
                          ),
                        ),
                      );
                    }),
              ),
              Divider(
                height: 1.0,
              )
            ],
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: _showFormDialog,
            child: new ListTile(
              title: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      },
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.red)),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: TextField(
            controller: _textFieldController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Task",
                labelStyle: TextStyle(color: Colors.redAccent, fontSize: 33.4),
                hintText: "e.g buy breads",
                icon: Icon(
                  Icons.add_alert,
                  color: Colors.redAccent,
                )),
          ))
        ],
      ),
      actions: <Widget>[
        new RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)),
            color: Colors.redAccent,
            onPressed: () {
              _handleSubmit(_textFieldController.text);
              _textFieldController.clear();
              Navigator.pop(context);
            },
            child: Text(
              "Save",
            )),
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.redAccent),
            ))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readTodoList() async {
    List items = await db.getAllItems();
    items.forEach((item) {
      setState(() {
        _itemsList.add(TodoItem.map(item));
      });
    });
  }

  void _handleSubmit(String text) async {
    TodoItem item = new TodoItem(text, dateFormatter());
    int savedItemId = await db.saveItem(item);
    TodoItem savedItem = await db.getTodoItem(savedItemId);
    setState(() {
      _itemsList.insert(0, savedItem);
    });
  }

  _handleDelete(int id, int index) async {
    await db.deleteItem(id);
    setState(() {
      _itemsList.removeAt(index);
    });
  }

  _updateItem(TodoItem item, int index) {
    var alert = new AlertDialog(
      title: Text("Update Item"),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.red)),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: TextField(
            controller: _textFieldController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Task",
                labelStyle: TextStyle(color: Colors.redAccent, fontSize: 33.4),
                hintText: "e.g buy breads",
                icon: Icon(
                  Icons.add_alert,
                  color: Colors.redAccent,
                )),
          ))
        ],
      ),
      actions: <Widget>[
        new RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)),
            color: Colors.redAccent,
            onPressed: () async {
              TodoItem updatedItem = TodoItem.fromMap({
                "itemName": _textFieldController.text,
                "dateCreated": dateFormatter(),
                "id": item.id
              });
              _handleUpdate(index, updatedItem);
              await db.updateItem(updatedItem);
              setState(() {
                _readTodoList();
              });
              _textFieldController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.redAccent),
            ))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleUpdate(int index, TodoItem updatedItem) {
    setState(() {
      _itemsList.removeWhere((element) {
        _itemsList[index].itemName == updatedItem.itemName;
      });
    });
  }
}

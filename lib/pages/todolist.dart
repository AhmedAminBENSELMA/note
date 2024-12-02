import 'package:flutter/material.dart';
import 'package:note_project/db/sql_helper.dart';
import 'package:note_project/models/todo.dart';
import 'package:note_project/pages/login.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<TodoModel> _todos = [];

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    List<TodoModel> todos = await DatabaseHelper.instance.fetchTodos();
    setState(() {
      _todos = todos;
    });
  }

  Future<void> _deleteTodo(int id) async {
    await DatabaseHelper.instance.deleteTodo(id);
    await _fetchTodos();
  }

  Future<void> _addTodo() async {
    // Show dialog to add new todo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String description = '';
        return AlertDialog(
          title: Text('Add New Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value) => description = value,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Add new todo
                TodoModel newTodo = TodoModel(
                  title: title,
                  description: description,
                );
                await DatabaseHelper.instance.insertTodo(newTodo);
                await _fetchTodos();
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateTodo(int id) async {
    TodoModel todoToUpdate = _todos.firstWhere((todo) => todo.id == id);
    // Show dialog to update todo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String updatedTitle = todoToUpdate.title;
        String updatedDescription = todoToUpdate.description;
        return AlertDialog(
          title: Text('Update Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => updatedTitle = value,
                controller: TextEditingController(text: todoToUpdate.title),
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value) => updatedDescription = value,
                controller:
                    TextEditingController(text: todoToUpdate.description),
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update todo
                TodoModel updatedTodo = TodoModel(
                  id: id,
                  title: updatedTitle,
                  description: updatedDescription,
                );
                await DatabaseHelper.instance.updateTodo(updatedTodo);
                await _fetchTodos();
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Add Todo'),
              onTap: _addTodo,
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (BuildContext context, int index) {
          TodoModel todo = _todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _updateTodo(todo.id!);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (todo.id != null) {
                      _deleteTodo(todo.id!);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String TODO_KEY = "todos";

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> todosList = [];
  final todoTextController = TextEditingController();

  addTodo() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tempTodos = prefs.getStringList(TODO_KEY) ?? [];
    tempTodos.add(todoTextController.text);
    prefs.setStringList(TODO_KEY, tempTodos);
    loadAllTodos();
  }

  loadAllTodos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      todosList = prefs.getStringList(TODO_KEY) ?? [];
    });
  }

  deleteTodo(int index) async {}

  @override
  void dispose() {
    todoTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: todosList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Column(children: [
                          Row(
                            children: [
                              Text(
                                "${todosList[index]}",
                                style: const TextStyle(fontSize: 20.0),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  deleteTodo(index);
                                },
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          const Divider(),
                        ]));
                  }),
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: todoTextController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter your Todo Text',
                        ),
                      ),
                    )
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: const Text("Add Todo"),
                    onPressed: addTodo,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

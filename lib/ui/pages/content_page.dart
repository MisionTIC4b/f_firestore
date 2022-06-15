import 'package:flutter/material.dart';
import 'package:mintic_un_todo_core/domain/models/to_do.dart';
import 'package:misiontic_todo/data/repositories/database.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  createState() => _State();
}

class _State extends State<ContentPage> {
  late TextEditingController _controller;
  late FirestoreDatabase databaseService;
  List<ToDo> todos = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    databaseService = FirestoreDatabase();
    databaseService.readAll().then((value) {
      print(value);
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de ToDos"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Nuevo To-Do",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final toDo = ToDo(content: _controller.text);
                        databaseService.save(data: toDo).then((_) {
                          setState(() {
                            _controller.clear();
                            todos.add(toDo);
                          });
                        });
                      },
                      child: const Text("Aceptar"))
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: todos.length,
                    itemBuilder: (ontext, index) {
                      final toDo = todos[index];
                      return ListTile(
                        leading: AbsorbPointer(
                          absorbing: toDo.completed,
                          child: IconButton(
                            icon: Icon(
                              toDo.completed
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color:
                                  toDo.completed ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              toDo.completed = true;
                              databaseService.update(data: toDo).then((value) {
                                setState(() {
                                  todos[index] = toDo;
                                });
                              });
                            },
                          ),
                        ),
                        title: Text(toDo.content),
                        trailing: IconButton(
                          onPressed: () {
                            databaseService.delete(uuid: toDo.uuid).then((_) {
                              setState(() {
                                todos.removeAt(index);
                              });
                            });
                          },
                          icon: const Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delete_sweep_rounded),
        onPressed: () {
          databaseService.clear(toDos: todos).then((_) {
            setState(() {
              todos.clear();
            });
          });
        },
      ),
    );
  }
}

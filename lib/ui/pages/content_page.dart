import 'package:flutter/material.dart';
import 'package:mintic_un_todo_core/mintic_un_todo_core.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  List<ToDo> todos = [];

  @override
  void initState() {
    super.initState();
    ToDoService.initialize().then(
      (_) => ToDoService.getAll().then(
        (value) {
          setState(() {
            todos = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Trabajar aquí'),
      ),
    );
  }
}

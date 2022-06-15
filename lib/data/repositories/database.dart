import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mintic_un_todo_core/data/entities/to_do.dart';
import 'package:mintic_un_todo_core/domain/models/to_do.dart';

class FirestoreDatabase {
  CollectionReference<Map<String, dynamic>> get database =>
      FirebaseFirestore.instance.collection("to-do_list");

  Stream<List<ToDo>> get toDoStream {
    return database.snapshots().map((event) {
      return event.docs
          .map((record) => ToDoEntity.fromRecord(record.data()))
          .toList();
    });
  }

  Future<void> delete({required String uuid}) async {
    await database.doc(uuid).delete();
  }

  Future<void> save({required ToDo data}) async {
    await database.doc(data.uuid).set(data.record);
  }

  Future<ToDo> read({required String uuid}) async {
    final snapshot = await database.doc(uuid).get();
    return ToDoEntity.fromRecord(snapshot.data()!);
  }

  Future<List<ToDo>> readAll() async {
    final snapshot = await database.get();
    return snapshot.docs
        .map((record) => ToDoEntity.fromRecord(record.data()))
        .toList();
  }

  Future<void> clear({required List<ToDo> toDos}) async {
    // Se solicita la lista para evitar obtenerlos de nuevo de Firestore y
    // duplicar operaciones de lectura.
    for (var toDo in toDos) {
      await database.doc(toDo.uuid).delete();
    }
  }

  Future<void> update({required ToDo data}) async {
    await database.doc(data.uuid).update(data.record);
  }
}

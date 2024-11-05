import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

@immutable
class Todo {
  final String id;
  final String description;
  final bool completed;

  const Todo(
      {required this.description, required this.id, this.completed = false});
}

class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => [];

  void create(String description) {
    state = [...state, Todo(id: _uuid.v4(), description: description)];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
              id: todo.id,
              description: todo.description,
              completed: !todo.completed)
        else
          todo
    ];
  }

  void delete(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}

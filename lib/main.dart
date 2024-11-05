import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'todo.dart';

final createTodoKey = UniqueKey();

final todoListProvider = NotifierProvider<TodoList, List<Todo>>(TodoList.new);

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Todo List',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Home());
  }
}

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final newTodoController = useTextEditingController();

    return Scaffold(
        appBar: AppBar(title: const Text('My Todos')),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            children: [
              TextField(
                  key: createTodoKey,
                  controller: newTodoController,
                  decoration: const InputDecoration(
                      labelText: 'What needs to be done?'),
                  onSubmitted: (value) {
                    ref.read(todoListProvider.notifier).create(value);
                    newTodoController.clear();
                  }),
              for (var i = 0; i < todos.length; ++i) ...[
                if (i > 0) const Divider(height: 0),
                Dismissible(
                    key: ValueKey(todos[i].id),
                    onDismissed: (_) {
                      ref.read(todoListProvider.notifier).delete(todos[i]);
                    },
                    child: ProviderScope(
                        overrides: [_currentTodo.overrideWithValue(todos[i])],
                        child: const TodoItem()))
              ]
            ]));
  }
}

final _currentTodo = Provider<Todo>((ref) => throw UnimplementedError());

class TodoItem extends HookConsumerWidget {
  const TodoItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(_currentTodo);

    return Material(
        elevation: 4,
        child: ListTile(
            leading: Checkbox(
                value: todo.completed,
                onChanged: (value) =>
                    ref.read(todoListProvider.notifier).toggle(todo.id)),
            title: Text(todo.description)));
  }
}

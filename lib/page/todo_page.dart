import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/todo_db.dart';
import '../model/todo.dart';
import '../widget/create_todo_widget.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({
    super.key,
  });

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Future<List<Todo>>? futureTodoList;
  final todoDB = TodoDB();

  @override
  void initState() {
    super.initState();
    fetchTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter SQL Database Storage Using Sqlite & Sqflite CRUD"),
      ),
      body: FutureBuilder(
        future: futureTodoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final todoList = snapshot.data!;
            return todoList.isEmpty
                ? const Center(
                    child: Text(
                      'No Todos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final todo = todoList[index];
                      final subtitle = DateFormat('yyyy/MM/dd').format(DateTime.parse(todo.updatedAt ?? todo.createdAt));
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        tileColor: Colors.black12,
                        title: Text(todo.title),
                        subtitle: Text(subtitle),
                        trailing: IconButton(
                          onPressed: () async {
                            await todoDB.delete(todo.id);
                            fetchTodoList();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CreateTodoWidget(
                              todo: todo,
                              onSubmit: (title) async {
                                await todoDB.update(
                                  id: todo.id,
                                  title: title,
                                );
                                fetchTodoList();
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12,
                    ),
                    itemCount: todoList.length,
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CreateTodoWidget(
              onSubmit: (String title) async {
                await todoDB.create(title: title);
                if (!mounted) return;
                fetchTodoList();
                Navigator.of(context).pop();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void fetchTodoList() {
    setState(() {
      futureTodoList = todoDB.fetchAll();
    });
  }
}

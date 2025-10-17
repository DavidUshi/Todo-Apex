import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/providers/todo_provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final todos = provider.todos;

    final doneTodos = todos.where((t) => t.done).toList();
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: const Text(
            'Done List',
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(205, 255, 86, 34),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: Icon(
                Provider.of<ThemeProvider>(context).isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: () {
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme();
              },
              tooltip: 'Toggle Theme',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: IconButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pushReplacementNamed(context, '/auth');
              },
              icon: Icon(Icons.logout, color: Colors.white),
              tooltip: 'logout',
            ),
          ),
        ],
      ),
      body: doneTodos.isEmpty
          ? const Center(child: Text('No Completed tasks yet.'))
          : ListView.builder(
              itemCount: doneTodos.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final todo = doneTodos[index];
                final formattedDate = DateFormat(
                  'yyyy-MM-dd',
                ).format(todo.createdAt);
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.deepOrange),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Created on: $formattedDate'),
                        if (todo.note != null && todo.note!.isEmpty)
                          Text('Note: ${todo.note}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../model/todo.dart';
import '../providers/theme_provider.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  DateTime selectedDate = DateTime.now();

  void _showAddEditDialog(BuildContext context, {Todo? todo}) {
    final titleCtrl = TextEditingController(text: todo?.title ?? '');
    final noteCtrl = TextEditingController(text: todo?.note ?? '');
    showDialog(
      context: context,
      builder: (context) {
        final isEditing = todo != null;
        return AlertDialog(
          title: Text(isEditing ? 'Edit Todo' : 'Add Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              onPressed: () async {
                final title = titleCtrl.text.trim();
                final note = noteCtrl.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title required')),
                  );
                  return;
                }
                final provider = context.read<TodoProvider>();
                if (isEditing) {
                  await provider.updateTodo(
                    todo.id,
                    title: title,
                    note: note.isEmpty ? null : note,
                  );
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Todo updated')));
                } else {
                  await provider.addTodo(
                    title: title,
                    note: note.isEmpty ? null : note,
                  );
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Todo added')));
                }
                Navigator.pop(context);
              },
              child: Text(
                isEditing ? 'Save' : 'Add',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    // Filter todos for selectedDate
    final filteredTodos = provider.todos.where((t) {
      return t.createdAt.year == selectedDate.year &&
          t.createdAt.month == selectedDate.month &&
          t.createdAt.day == selectedDate.day;
    }).toList();

    bool isFuture = selectedDate.isAfter(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: const Text(
            'Today Tasks',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // ✅ center row
              children: [
                Text(
                  DateFormat('EEEE, MMM d, yyyy').format(selectedDate),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _pickDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                  child: const Icon(Icons.calendar_today, color: Colors.white),
                ),
              ],
            ),
          ),

          if (isFuture)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "No tasks yet for future dates!",
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // ✅ Todo list
          Expanded(
            child: filteredTodos.isEmpty
                ? const Center(child: Text('No todos for this date.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, i) {
                      final todo = filteredTodos[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.done,
                            activeColor: Colors.deepOrange,
                            onChanged: (_) => provider.toggleTodoDone(todo.id),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.done
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: todo.note == null
                              ? Text(
                                  'Created at: ${DateFormat('kk:mm').format(todo.createdAt)}',
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Created at: ${DateFormat('kk:mm').format(todo.createdAt)}',
                                    ),
                                    Text('Note: ${todo.note}'),
                                  ],
                                ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.deepOrange,
                            ),
                            onPressed: () =>
                                _showAddEditDialog(context, todo: todo),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () => _showAddEditDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

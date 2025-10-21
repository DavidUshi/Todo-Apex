import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/todo.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;
  const TodoDetailScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (todo.note != null && todo.note!.isNotEmpty)
              Text('note: ${todo.note!}', style: const TextStyle(fontSize: 16))
            else
              const Text(
                'No additional notes',
                style: TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 20),
            Text(
              'Created: ${DateFormat('MMM d, yyyy – hh:mm a').format(todo.createdAt)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  todo.done ? 'Completed ✅' : 'Pending ⏳',
                  style: TextStyle(
                    color: todo.done ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

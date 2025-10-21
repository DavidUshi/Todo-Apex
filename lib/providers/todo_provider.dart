import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/todo.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  static const _storageKey = 'todos_v1';
  final List<Todo> _todos = [];
  bool _initialized = false;

  List<Todo> get todos => List.unmodifiable(_todos);

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final List<dynamic> arr = json.decode(raw);
        _todos.clear();
        _todos.addAll(
          arr.map((e) => Todo.fromMap(Map<String, dynamic>.from(e))),
        );
      } catch (e) {
        _todos.clear();
      }
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final arr = _todos.map((t) => t.toMap()).toList();
    await prefs.setString(_storageKey, json.encode(arr));
  }

  Future<void> addTodo({
    required String title,
    String? note,
    DateTime? date,
  }) async {
    final id = const Uuid().v4();
    final todo = Todo(
      id: id,
      title: title,
      note: note,
      createdAt: date ?? DateTime.now(),
    );
    _todos.insert(0, todo);
    await _saveToDisk();
    notifyListeners();
  }

  Future<void> updateTodo(
    String id, {
    String? title,
    String? note,
    bool? done,
  }) async {
    final idx = _todos.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    final old = _todos[idx];
    _todos[idx] = Todo(
      id: old.id,
      title: title ?? old.title,
      note: note ?? old.note,
      done: done ?? old.done,
      createdAt: old.createdAt,
    );
    await _saveToDisk();
    notifyListeners();
  }

  Future<void> toggleTodoDone(String id) async {
    final idx = _todos.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _todos[idx] = Todo(
      id: _todos[idx].id,
      title: _todos[idx].title,
      note: _todos[idx].note,
      done: !_todos[idx].done,
      createdAt: _todos[idx].createdAt,
    );
    await _saveToDisk();
    notifyListeners();
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
    await _saveToDisk();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _todos.clear();
    await _saveToDisk();
    notifyListeners();
  }
}

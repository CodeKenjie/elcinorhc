import 'package:flutter/foundation.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/get_all.dart';
import '../../domain/usecases/add.dart';
import '../../domain/usecases/update.dart';
import '../../domain/usecases/update_status.dart';
import '../../domain/usecases/delete.dart';

class TodoController extends ChangeNotifier {
  final Add addUseCase;
  final GetAll getAllUseCase;
  final Update updateUseCase;
  final UpdateStatus updateStatusUseCase;
  final Delete deleteUseCase;

  TodoController({
    required this.addUseCase,
    required this.getAllUseCase,
    required this.updateStatusUseCase,
    required this.updateUseCase,
    required this.deleteUseCase
  });

  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _formattedError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<bool> loadTodos() async {
    _clearError();
    _setLoading(true);
    try {
      _todos = await getAllUseCase();
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> create({ required String title, DateTime? expiresAt }) async {
    _clearError();
    _setLoading(true);
    try {
      final todo = await addUseCase( title: title, expiresAt: expiresAt );
      _todos.add(todo);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> update({ required int id, required String title, DateTime? expiresAt }) async {
    _clearError();
    _setLoading(true);
    try {
      await updateUseCase( id: id, title: title, expiresAt: expiresAt );

      final index = _todos.indexWhere((todo) => todo.id == id);
      if(index != -1) {
        final oldTodo = _todos[index];
        _todos[index] = Todo( 
          id: oldTodo.id,
          title: title,
          completed: oldTodo.completed,
          createdAt: oldTodo.createdAt,
          expiresAt: expiresAt
        );
      }

      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateStatus({ required int id, required bool completed }) async {
    _clearError();
    _setLoading(true);
    try {
      await updateStatusUseCase( id: id, completed: completed );
      final index = _todos.indexWhere((todo) => todo.id == id);

      if(index != -1) {
        final oldTodo = _todos[index];
        _todos[index] = Todo(
          id: oldTodo.id,
          title: oldTodo.title,
          completed: completed,
          createdAt: oldTodo.createdAt,
          expiresAt: oldTodo.expiresAt
        );
      }

      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> delete(int id) async {
    _clearError();
    _setLoading(true);
    try {
      await deleteUseCase(id);
      _todos.removeWhere((todo) => todo.id == id);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
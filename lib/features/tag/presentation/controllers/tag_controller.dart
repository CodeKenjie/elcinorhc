import 'package:flutter/foundation.dart';
import '../../domain/entities/tag.dart';
import '../../domain/usecases/get_tags.dart';
import '../../domain/usecases/journal_tags.dart';
import '../../domain/usecases/get_tag.dart';
import '../../domain/usecases/create_tag.dart';
import '../../domain/usecases/delete_tag.dart';

class TagController extends ChangeNotifier {
  final GetTags getTagsUseCase;
  final GetTag getTagUseCase;
  final CreateTag createTagUseCase;
  final DeleteTag deleteTagUseCase;
  final GetJournalTags getJournalTagsUseCase;

  TagController({
    required this.getTagsUseCase,
    required this.getTagUseCase,
    required this.createTagUseCase,
    required this.deleteTagUseCase,
    required this.getJournalTagsUseCase
  });

  List<Tag> _tags = [];
  Tag? _tag;
  bool _isLoading = false;
  String? _errorMessage;

  List<Tag> get tags => _tags;
  Tag? get tag => _tag;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _clearError() {
    _errorMessage = null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _formattedError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<List<Tag>> getJournalTags(int journalId) async {
    _clearError();
    try {
      return List<Tag>.from(await getJournalTagsUseCase(journalId));
    } catch (err) {
      _errorMessage = _formattedError(err);
      return [];
    }
  }

  Future<bool> getTags() async {
    _clearError();
    _setLoading(true);
    try {
      _tags = List<Tag>.from(await getTagsUseCase());
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> getTag(int id) async {
    _clearError();
    _setLoading(true);
    try {
      _tag = await getTagUseCase(id);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> create ({ required String name }) async {
    _clearError();
    _setLoading(true);
    try {
      final tag = await createTagUseCase(name: name);
      _tags.add(tag);
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
      await deleteTagUseCase(id);
      _tags.removeWhere((tag) => tag.id == id);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }

  }
}
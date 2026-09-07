import 'package:flutter/foundation.dart';
import '../../domain/entities/journal_tag.dart';
import '../../domain/usecases/create_journal_tag.dart';
import '../../domain/usecases/delete_journal_tag.dart';
import '../../domain/usecases/get_all_journal_tags.dart';

class JournalTagController extends ChangeNotifier {
  final CreateJournalTag createJournalTagUseCase;
  final DeleteJournalTag deleteJournalTagUseCase;
  final GetAllJournalTags getJournalTagsUseCase;

  JournalTagController({
    required this.createJournalTagUseCase,
    required this.deleteJournalTagUseCase,
    required this.getJournalTagsUseCase
  });

  List<JournalTag> _journalTags = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<JournalTag> get journalTags => _journalTags; 
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

  Future<bool> getJournalTag(int journalId) async {
    _clearError();
    _setLoading(true);
    try {
      _journalTags = await getJournalTagsUseCase(journalId);
      return true;
    } catch(err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> create({required int tagId, required int journalId }) async {
    _clearError();
    _setLoading(true);
    try {
      final journal = await createJournalTagUseCase( tagId: tagId, journalId: journalId );
      _journalTags.add(journal);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> delete({ required int journalId, required tagId }) async {
    _clearError();
    _setLoading(true);
    try {
      await deleteJournalTagUseCase(journalId: journalId, tagId: tagId);
      _journalTags.removeWhere((journalTag) => journalTag.journalId == journalId && journalTag.tagId == tagId );
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
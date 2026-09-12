import 'package:flutter/foundation.dart';
import '../../domain/entities/journal.dart';
import '../../domain/entities/shared_journal.dart';
import '../../domain/usecases/create_journal.dart';
import '../../domain/usecases/get_journals.dart';
import '../../domain/usecases/get_journal.dart';
import '../../domain/usecases/edit_journal.dart';
import '../../domain/usecases/delete_journal.dart';
import '../../domain/usecases/share_journal.dart';
import '../../domain/usecases/get_shared_journal.dart';
import '../../domain/usecases/update_shared_journal.dart';
import '../../domain/usecases/delete_shared_journal.dart';

class JournalController extends ChangeNotifier {
  final CreateJournal createJournalUseCase;
  final GetJournals getJournalsUseCase;
  final GetJournal getJournalUseCase;
  final EditJournal editJournalUseCase;
  final DeleteJournal deleteJournalUseCase;
  final ShareJournal shareJournalUseCase;
  final GetSharedJournal getSharedJournalUseCase;
  final UpdateSharedJournal updateSharedJournalUseCase;
  final DeleteSharedJournal deleteSharedJournalUseCase;

  JournalController({
    required this.createJournalUseCase,
    required this.getJournalsUseCase,
    required this.getJournalUseCase,
    required this.editJournalUseCase,
    required this.deleteJournalUseCase,
    required this.shareJournalUseCase,
    required this.getSharedJournalUseCase,
    required this.updateSharedJournalUseCase,
    required this.deleteSharedJournalUseCase
  });

  List<Journal> _journals = [];
  List<SharedJournal> _sharedJournals = [];
  Journal? _journal;
  bool _isLoading = false;
  String? _errorMessage;

  List<Journal> get journals => _journals;
  List<SharedJournal> get sharedJournals => _sharedJournals;
  Journal? get journal => _journal;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int? sharingJournal;

  bool isSharing(int journalId) {
    return sharingJournal == journalId;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError(){
    _errorMessage = null;
  }

  String _formattedError(Object error) {
    return error.toString().replaceFirst("Exception: ", '');
  }

  Future<bool> getJournals() async {
    _clearError();
    _setLoading(true);

    try {
      _journals = List<Journal>.from(await getJournalsUseCase());
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> getJournal(int id) async {
    _clearError();
    _setLoading(true);

    try {
      _journal = await getJournalUseCase(id);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> create({ 
    required String title,
    required String body
  }) async {
    _clearError();
    _setLoading(true);

    try {
      final journal = await createJournalUseCase(title: title, body: body);

      _journals.add(journal);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> edit({
    required int id,
    required String title,
    required String body,
  }) async {
    _clearError();
    _setLoading(true);

    try {
      await editJournalUseCase(id: id, title: title, body: body);

      final index = _journals.indexWhere((journal) => journal.id == id);

      if(index != -1) {
        _journals[index] = _journals[index].copyWith(
          title: title, 
          body: body
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
      await deleteJournalUseCase(id);
      _journals.removeWhere((journal) => journal.id == id);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> getSharedJournal() async {
    _clearError();
    _setLoading(true);
    try{
      _sharedJournals = await getSharedJournalUseCase();
      return true;
    } catch(err) {
      _errorMessage = _formattedError(err);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> shareJournal({
    required String userUid,
    required Journal journal
  }) async {
    _clearError();

    sharingJournal = journal.id;
    _setLoading(true);

    try{
      final sharedJournal = await shareJournalUseCase(
        userUid: userUid,
        journal: journal
      );

      _sharedJournals.add(sharedJournal);
      return true;
    } catch(err) {
      _errorMessage = _formattedError(err);
      notifyListeners();
      return false;
    } finally {
      sharingJournal = null;
      _setLoading(false);
    }
  }

  Future<bool> updateSharedJournal({
    required String journalUid,
    required String title,
    required String body,
  }) async {
    _clearError();
    _setLoading(true);

    try {
      await updateSharedJournalUseCase(sharedJournalUid: journalUid, title: title, body: body);

      final index = _sharedJournals.indexWhere((sharedJournal) => sharedJournal.uid == journalUid);

      if(index != -1) {
        final old = _sharedJournals[index];

        _sharedJournals[index] = old.copyWith(
          journal: old.journal.copyWith(
            title: title,
            body: body
          )
        );
      }

      return true;
    } catch(err) {
      _errorMessage = _formattedError(err);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteSharedJournal(String sharedJournalUid) async {
    _clearError();
    _setLoading(true);
    try{
      await deleteSharedJournalUseCase(sharedJournalUid);
      _sharedJournals.removeWhere((journal) => journal.uid == sharedJournalUid);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
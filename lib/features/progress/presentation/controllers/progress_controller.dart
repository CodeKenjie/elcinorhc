import 'package:flutter/foundation.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/usecases/get_user_progress.dart';

class ProgressController extends ChangeNotifier {
  final GetUserProgress getUserProgressUseCase;

  ProgressController({
    required this.getUserProgressUseCase
  });

  UserProgress? _progress;
  bool _isLoading = false;
  String? _errorMessage;

  UserProgress? get progress => _progress;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _clearError() {
    _errorMessage = null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> loadProgress() async {
    _clearError();
    _setLoading(true);

    try {
      _progress = await getUserProgressUseCase.execute();
      return true;
    } catch (err) {
      _errorMessage = err.toString().replaceFirst("Exception: ", '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
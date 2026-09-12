import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/user_sign_up.dart';
import '../../domain/usecases/user_sign_in.dart';
import '../../domain/usecases/user_sign_out.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/get_users.dart';

class AuthController extends ChangeNotifier {
  final UserSignUp userSignUpUseCase;
  final UserSignIn userSignInUseCase;
  final UserSignOut userSignOutUseCase;
  final GetCurrentUser getCurrentUserUseCase;
  final GetUsers getUsersUseCase;

  AuthController({
    required this.userSignUpUseCase,
    required this.userSignInUseCase,
    required this.userSignOutUseCase,
    required this.getCurrentUserUseCase,
    required this.getUsersUseCase
  }) { 
    loadCurrentUser(); 
  }

  User? _user;
  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  void _clearError(){
    _errorMessage = null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? _formattedError(Object error) {
    return error.toString().replaceFirst('Exceptions: ', '');
  }

  Future<bool> loadUsers() async {
    _clearError();
    _setLoading(true);
    try {
      _users = await getUsersUseCase();
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String email,
    required String password,
    required String confirmedPassword
  }) async {
    _clearError();

    if(firstName.trim().isEmpty) {
      _errorMessage = "First name can't be blank.";
      notifyListeners();
      return false;
    }

    if(lastName.trim().isEmpty) {
      _errorMessage = "Last name can't be blank.";
      notifyListeners();
      return false;
    }

    if(email.trim().isEmpty) {
      _errorMessage = "Email name can't be blank.";
      notifyListeners();
      return false;
    }

    if(password.length < 8) {
      _errorMessage = "Password must be at least 8 characters.";
      notifyListeners();
      return false;
    }

    if(confirmedPassword != password) {
      _errorMessage = "Confirm password and password did not match.";
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final normalizedEmail = email.trim().toLowerCase();
      _user = await userSignUpUseCase(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        email: normalizedEmail,
        password: password
      );
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn ({
    required String email, 
    required String password 
  }) async {
    _clearError();

    if(email.trim().isEmpty) {
      _errorMessage = "Email can't be blank.";
      notifyListeners();
      return false;
    }

    if(password.trim().isEmpty) {
      _errorMessage = "Please enter a password.";
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final normalizedEmail = email.trim().toLowerCase();
      _user = await userSignInUseCase(email: normalizedEmail, password: password);
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signOut() async {
    _clearError();
    _setLoading(true);
    try {
      await userSignOutUseCase();
      _user = null;
      return true;
    } catch (err) {
      _errorMessage = _formattedError(err);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loadCurrentUser() async {
    try {
      _user = await getCurrentUserUseCase();
      notifyListeners();
      return true;
    } catch (err) {
      _user = null;
      _errorMessage = _formattedError(err);
      notifyListeners();
      return false;
    }
  }
}
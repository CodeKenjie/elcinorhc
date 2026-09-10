import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class UserSignIn {
  final AuthRepository repository;

  const UserSignIn(this.repository);

  Future<User> call ({ required String email, required String password }) {
    return repository.signIn(email: email, password: password);
  }
}
import '../repositories/auth_repository.dart';

class UserSignOut {
  final AuthRepository repository;

  const UserSignOut(this.repository);

  Future<void> call () {
    return repository.signOut();
  }
}
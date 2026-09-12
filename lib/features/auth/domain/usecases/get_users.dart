import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class GetUsers {
  final AuthRepository repository;
  const GetUsers(this.repository);

  Future<List<User>> call () {
    return repository.getUsers();
  }
}
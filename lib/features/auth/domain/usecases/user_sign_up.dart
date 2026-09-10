import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class UserSignUp {
  final AuthRepository repository;

  const UserSignUp(this.repository);

  Future<User> call ({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String email,
    required String password,
  }) {
    return repository.signUp(
      firstName: firstName, 
      lastName: lastName, 
      dateOfBirth: dateOfBirth, 
      email: email, 
      password: password
    );
  }
}
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> signUp({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String email,
    required String password
  }) {
    return remoteDataSource.signUp(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      email: email,
      password: password
    );
  }

  @override
  Future<User> signIn({
    required String email,
    required String password
  }) {
    return remoteDataSource.signIn(
      email: email,
      password: password
    );
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }

  @override
  Future<List<User>> getUsers() {
    return remoteDataSource.getUsers();
  }

  @override
  Future<User> getCurrentUser(){
    return remoteDataSource.getCurrentUser();
  }

  @override
  Stream<User?> authStateChanges() {
    return remoteDataSource.authStateChanges();
  }
}
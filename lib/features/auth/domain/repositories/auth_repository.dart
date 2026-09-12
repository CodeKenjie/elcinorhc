import '../entities/user.dart';
abstract class AuthRepository {
  Future<User> signUp({ 
    required String firstName, 
    required String lastName,
    required DateTime dateOfBirth,
    required String email,
    required String password
  });

  Future<User> signIn({ required String email, required String password });

  Future<void> signOut();

  Future<List<User>> getUsers();

  Future<User> getCurrentUser();

  Stream<User?> authStateChanges();
}
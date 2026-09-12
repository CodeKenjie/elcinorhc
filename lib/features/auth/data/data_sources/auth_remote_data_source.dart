import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elcinorch/core/services/auth_service.dart';
import '../model/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseFirestore instance;
  final AuthService auth;

  AuthRemoteDataSource({
    FirebaseFirestore? firestore,
    required this.auth
  }) : instance = firestore ?? FirebaseFirestore.instance;

  Future<UserModel> signUp({ 
    required String firstName, 
    required String lastName, 
    required DateTime dateOfBirth,
    required String email, 
    required String password
  }) async {
    final user = await auth.signUp(email: email, password: password);

    if(user == null) {
      throw Exception('Sign up failed.');
    }

    await instance.collection('users').doc(user.uid).set({
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': Timestamp.fromDate(dateOfBirth),
      'email_address': user.email ?? email,
    });

    return UserModel(
      uid: user.uid, 
      firstName: firstName, 
      lastName: lastName, 
      dateOfBirth: dateOfBirth, 
      email: user.email ?? email, 
    );
  }

  Future<List<UserModel>> getUsers() async {
    final snapshot = await instance.collection('users').get();

    if(snapshot.docs.isEmpty){
      throw Exception('User not found.');
    }

    return snapshot.docs.map((user) => UserModel(
      uid: user.id, 
      firstName: user['first_name'], 
      lastName: user['last_name'], 
      dateOfBirth: (user['date_of_birth'] as Timestamp).toDate(), 
      email: user['email_address']
    )).toList();
  }

  Future<UserModel> signIn({
    required String email,
    required String password
  }) async {
    final authUser = await auth.signIn(email: email, password: password);

    if(authUser == null) {
      throw Exception('Authentication Failed.');
    }

    final snapshot = await instance.collection('users').doc(authUser.uid).get();

    if(!snapshot.exists){
      throw Exception('User not found.');
    }

    return UserModel.fromFirestore(authUser.uid, snapshot.data()!);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<UserModel> getCurrentUser() async {
    final user = auth.currentUser;

    if(user == null) {
      throw Exception('Failed to find user');
    }

    final snapshot = await instance.collection('users').doc(user.uid).get();

    if(!snapshot.exists || snapshot.data() == null){
      throw Exception('User not found.');
    }

    return UserModel.fromFirestore(user.uid, snapshot.data()!);
  }

  Stream<UserModel?> authStateChanges() async* {
    await for (final firebaseUser in auth.authStateChanges) {
      if(firebaseUser == null) {
        yield null;
        continue;
      }

      final document = await instance.collection('users').doc(firebaseUser.uid).get();

      if(!document.exists || document.data() == null) {
        yield null;
        continue;
      }

      yield UserModel.fromFirestore(firebaseUser.uid, document.data()!);
    }
  }
}
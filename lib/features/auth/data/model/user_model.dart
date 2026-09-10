import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.uid,
    required super.firstName,
    required super.lastName,
    required super.dateOfBirth,
    required super.email,
  });

  factory UserModel.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid, 
      firstName: data['first_name'], 
      lastName: data['last_name'], 
      dateOfBirth: (data['date_of_birth'] as Timestamp).toDate(), 
      email: data['email_address']
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': Timestamp.fromDate(dateOfBirth),
      'email_address': email
    };
  }
}
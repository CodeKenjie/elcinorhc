class User {
  final String uid;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String email;

  const User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.email,
  });
}
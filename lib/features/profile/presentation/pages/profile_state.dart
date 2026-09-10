import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'unauthenticated_page.dart';
import 'authenticated_page.dart';

class ProfileState extends StatelessWidget {
  const ProfileState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator()
            ),
          );
        }

        if(snapshot.hasData) {
          return const AuthenticatedPage();
        } else {
          return const UnauthenticatedPage();
        }
      }
    );
  }
}
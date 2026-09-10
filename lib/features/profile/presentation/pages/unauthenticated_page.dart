import 'package:flutter/material.dart';
import 'package:elcinorch/features/auth/presentation/pages/sign_in_page.dart';
import 'package:elcinorch/features/auth/presentation/pages/sign_up_page.dart';

class UnauthenticatedPage extends StatelessWidget {
  const UnauthenticatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'E L C I N',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30)
            ),
            const Text(
              'O R H C', 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30)
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => SignInPage())
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Center(
                  child: Text(
                    'I already have an account', 
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface
                    ),
                  )
                )
              )
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage()
                  )
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Center(
                  child: Text(
                    'I want to make an account', 
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                )
              )
            ),
          ],
        ),
      )
    );
  }
}
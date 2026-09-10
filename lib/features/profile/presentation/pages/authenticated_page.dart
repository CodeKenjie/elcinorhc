import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';
import 'package:intl/intl.dart';

class AuthenticatedPage extends StatefulWidget {
  const AuthenticatedPage({super.key});

  @override
  State<AuthenticatedPage> createState() => _AuthenticatedPageState();
}

class _AuthenticatedPageState extends State<AuthenticatedPage> {
  final authController = AppDependencies.authController;

  String nameInitial(String firstName) {
    if(firstName.contains(" ")) {
      final List<String> name = firstName.trim().split(RegExp(r'\s+'));
      return "${name[0][0].toUpperCase()}${name[1][0].toUpperCase()}";
    } else {
      return firstName[0].toUpperCase();
    }
  }

  String _formattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date).toString();
  }

  String _capitalize(String string) {
    return string.trim().split(RegExp(r'\s+')).map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}').join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authController, 
      builder: (context, child) {
        final user = authController.user;

        if(user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column (
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Text(nameInitial(user.firstName), style: TextStyle(fontSize: 30)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _capitalize("${user.firstName} ${user.lastName}"),
                              style: TextStyle(
                                fontSize: 24
                              ),
                            ),
                            Text(
                              user.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.tertiary
                              ),
                            ),
                            Text(
                              _formattedDate(user.dateOfBirth),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.tertiary
                              ),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                    itemBuilder: (context, index) {
                      return Text(user.uid);
                    }
                  )
                )
              ],
            )
          ),
        );   
      }
    );
  }
}
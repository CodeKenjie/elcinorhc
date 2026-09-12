import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final authController = AppDependencies.authController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obsscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if(authController.isLoading) return;

    final email = _emailController.text;
    final password = _passwordController.text;

    final success = await authController.signIn(
      email: email, 
      password: password
    );

    if(!mounted) return;
    if(!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authController.errorMessage ?? 'Something went wrong.')));
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: ListenableBuilder(
            listenable: authController, 
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'you@domain.com',
                      labelText: 'Email Address'
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: obsscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obsscureText = !obsscureText;
                          });
                        }, 
                        icon: obsscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off)
                      )
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _submit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color.fromARGB(255, 76, 175, 142),
                          ),
                          child: authController.isLoading
                            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary)) :  Text(
                              'Sign in', 
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white
                              )
                            ),
                        ),
                      )
                    ],
                  )
                ],
              );
            }
          ),
       ),
      )
    );
  }
}
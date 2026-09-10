import 'package:flutter/material.dart';
import 'package:elcinorch/app/dependencies.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final authController = AppDependencies.authController;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _dateOfBirth;
  bool obscureText = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if(_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select your birth date')));
      return;
    }

    final success = await authController.signUp(
      firstName: firstName, 
      lastName: lastName, 
      dateOfBirth: _dateOfBirth!, 
      email: email, 
      password: password, 
      confirmedPassword: confirmPassword
    );

    if(!mounted) return;

    if(!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authController.errorMessage ?? 'Something went wrong.')));
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context){
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
                    'Sign up', 
                    style: TextStyle(
                      fontSize: 30,
                    )
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'John',
                      labelText: 'First Name'
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Doe',
                      labelText: 'Last Name'
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Colors.black)
                    ),
                    leading: const Icon(Icons.calendar_month),
                    title: _dateOfBirth != null ? Text('${_dateOfBirth!.year}/${_dateOfBirth!.day}/${_dateOfBirth!.month}') : Text('Date of birth'),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context, 
                        initialDate: DateTime(2003, 1, 1),
                        firstDate: DateTime(1700), 
                        lastDate: DateTime(3064)
                      );

                      if(pickedDate != null) {
                        setState(() {
                          _dateOfBirth = pickedDate;
                        });
                      }
                    }
                  ),
                  const SizedBox(height: 16),
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
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        }, 
                        icon: obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off)
                      )
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        }, 
                        icon: obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off)
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
                            color: Theme.of(context).colorScheme.primary
                          ),
                          child: authController.isLoading 
                            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary)) : Text(
                              'Sign up', 
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.surface
                              )
                            ),
                        ),
                      )
                    ],
                  )
                ],
              );
            }
          )
        )
      )
    );
  }
}
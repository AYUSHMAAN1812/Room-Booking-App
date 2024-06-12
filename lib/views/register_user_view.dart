import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:room_booking/constants/routes.dart';
import 'package:room_booking/services/auth/auth_exceptions.dart';
import 'package:room_booking/services/auth/auth_service.dart';
import 'package:room_booking/services/event/event_service.dart';
import 'package:room_booking/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isLoading = false;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> initializeUserToken(String email,String name) async {
    try {
      final token = await MessagingService().getToken();
      if (token != null) {
        await FirestoreService().setUserToken(email, name,token);
      }
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, 'Failed to get user token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 150.0, 16.0, 16.0),
            child: Column(
              children: [
                const Text(
                  'Register As User',
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                const SizedBox(height: 50.0),
                TextField(
                  controller: _name,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: "Enter your name here",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: "Enter your email here",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: "Enter your password here",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 80.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 15, // Font size
                      fontFamily: 'Roboto', // Font family
                      fontWeight: FontWeight.bold, // Font weight
                    ),
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          final name = _name.text;
                          final email = _email.text;
                          final password = _password.text;

                          if (email.isEmpty || password.isEmpty || name.isEmpty) {
                            showErrorDialog(
                                context, 'Please fill in all the fields');
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          }

                          try {
                            await AuthService.firebase().createUser(
                              email: email,
                              password: password,
                            );

                            final user = AuthService.firebase().currentUser;
                            if (user?.isEmailVerified ?? false) {
                              if (!context.mounted) return;
                              Navigator.of(context).pushNamed(userEventsRoute);
                            } else {
                              await initializeUserToken(email,name);
                              if (!context.mounted) return;
                              Navigator.of(context).pushNamed(verifyEmailRoute);
                            }
                          } on WeakPasswordAuthException {
                            showErrorDialog(context, 'Weak Password');
                          } on EmailAlreadyInUseAuthException {
                            showErrorDialog(context, 'Email is already in use');
                          } on InvalidEmailAuthException {
                            showErrorDialog(context, 'Invalid Email');
                          } on GenericAuthException {
                            showErrorDialog(context, 'Failed To Register');
                          } catch (e) {
                            log('Error: $e');
                            if (!context.mounted) return;
                            showErrorDialog(context, 'Error: $e');
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Register'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 15, // Font size
                      fontFamily: 'Roboto', // Font family
                      fontWeight: FontWeight.bold, // Font weight
                    ),
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(userLoginRoute);
                  },
                  child: const Text("Already registered? Login here"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:room_booking/constants/routes.dart';
import 'package:room_booking/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text('Verify email'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "We've sent you an email verification your account\n",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.purple),
            ),
            const Text(
              "If you haven't received a verification email yet, press the button below\n",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.purple),
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
              onPressed: () async {
                AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send email verification'),
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
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamed(
                    homePage,
                  );
                },
                child: const Text('Restart'))
          ],
        ),
      ),
    );
  }
}

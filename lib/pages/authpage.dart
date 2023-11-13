import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tase/pages/homepage.dart';
import 'package:tase/pages/loginorregisterpage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is looged in
          if (snapshot.hasData){
            return HomePage();
          }

          //user not logged in
          else {
            return LoginOrRegisterPage();
          }
        },
        ),
    );
  }
}
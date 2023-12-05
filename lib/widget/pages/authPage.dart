import 'package:folks/api/api_helper.dart';
import 'package:folks/folks.dart';
import 'package:folks/widget/pages/loginOrRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folks/widget/suggested_folks.dart';
import 'home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Folks();
          } else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}

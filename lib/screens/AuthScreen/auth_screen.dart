import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutee/screens/HomeScreen/home_screen.dart';
import 'package:flutee/services/authentication/sign_in_google.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Image.asset('assets/images/flutter_logo.png'),
              width: 300,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 70),
              child: RaisedButton(
                padding: EdgeInsets.all(12),
                onPressed: () => onSignIn(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.google),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Login with Google',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void onSignIn(BuildContext context) async {
  final User user = await signInWithGoogle();
  Future.delayed(Duration.zero, () {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
        (route) => false);
  });
}

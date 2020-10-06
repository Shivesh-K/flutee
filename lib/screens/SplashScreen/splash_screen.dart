import 'package:flutee/screens/AuthScreen/auth_screen.dart';
import 'package:flutee/screens/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    final User user = FirebaseAuth.instance.currentUser;
    // try{
    if (user == null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AuthScreen()));
      });
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
      });
    }

    // }
    // catch((identifier) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutee/Widgets/my_bottom_navigation_bar.dart';
import 'package:flutee/screens/ChatListScreen/chat_list_screen.dart';
import 'package:flutee/screens/ProfileScreen/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key key, this.user}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(top: false, child: getScreen(currentIndex)),
      bottomNavigationBar: CustomBottomNavigationBar(setScreen: (i) {
        setState(() {
          currentIndex = i;
        });
      }),
    );
  }

  Widget getScreen(int i) {
    switch (i) {
      case 0:
        return ChatListScreen(
          user: widget.user,
        );
      case 1:
        return ProfileScreen(user: widget.user);
      default:
        return ChatListScreen(
          user: widget.user,
        );
    }
  }
}

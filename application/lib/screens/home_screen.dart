import 'package:application/screens/Signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                child: const Text("LOGOUT"),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    print("Signed Out");
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 100),
                                  transitionsBuilder: ((context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child,)),
                                  pageBuilder: ((context, animation, secondaryAnimation) => SignInScreen())));
                  });
                })));
  }
}

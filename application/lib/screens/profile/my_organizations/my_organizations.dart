import 'package:application/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrgs extends StatefulWidget {
  const MyOrgs({super.key});

  @override
  State<MyOrgs> createState() => _MyOrgsState();
}

class _MyOrgsState extends State<MyOrgs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: true,
          title: Text("My Organizations", style: Theme.of(context).textTheme.headline6),
          backgroundColor: Colors.teal,
        ),
        body: Center(
            child: ElevatedButton(
                child: const Text("LOGOUT"),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    print("Signed Out");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  });
                })));
  }
}
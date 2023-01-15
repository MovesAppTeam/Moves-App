import 'dart:io';

import 'package:application/data_class/events_data.dart';
import 'package:application/data_class/user_class.dart';
import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/bottom_navigation.dart';
import 'package:application/screens/splash/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/color_utils.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final db = FirebaseFirestore.instance.collection("userList");
  final user = FirebaseAuth.instance.currentUser;
  final storage = FirebaseStorage.instance;
  final List _orgList = [];
  final List<Event> _eventList = [];
  final List _friends = [];
  final string1 = "assets/profile_headshots/${imgRandom()}";
  late final File file;
  late final NewUser newUser;
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              hexStringToColor("57E2E5"),
              hexStringToColor("6A7FDB"),
              hexStringToColor("45CB85")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            "Enter Username",
                            Icons.person_outline,
                            false,
                            _userNameTextController,
                            () {},
                            Colors.white.withOpacity(0.9),
                            Colors.black,
                            Colors.white.withOpacity(0.3)),
                        const SizedBox(
                          height: 30,
                        ),
                        reusableTextField(
                            "Enter Email",
                            Icons.person_outline,
                            false,
                            _emailTextController,
                            () {},
                            Colors.white.withOpacity(0.9),
                            Colors.black,
                            Colors.white.withOpacity(0.3)),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            "Enter Password",
                            Icons.lock_outline,
                            true,
                            _passwordTextController,
                            () {},
                            Colors.white.withOpacity(0.9),
                            Colors.black,
                            Colors.white.withOpacity(0.3)),
                        const SizedBox(
                          height: 20,
                        ),
                        signInSignUpButton(context, false, () {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text)
                              .then((value) async {
                            final user = FirebaseAuth.instance.currentUser;
                            try {
                              await user!.updateDisplayName(
                                  _userNameTextController.text);
                              await user.updatePhotoURL(string1).then((value) => user.reload());
                              
                            } catch (error) {
                              print(error);
                            }

                            newUser = NewUser(
                                imagePath: string1,
                                name: _userNameTextController.text,
                                phoneNumber: "",
                                email: _emailTextController.text,
                                myOrgs: _orgList,
                                friends: _friends,
                                events: _eventList,
                                about: "");
                            db.doc(user!.uid).set(newUser.toMap());
                            db
                                .doc(user.uid)
                                .collection("Chats")
                                .doc("Count")
                                .set({'count': 0});
                            db
                                .doc(user.uid)
                                .collection("Chats")
                                .doc("Messages")
                                .set({"owner": user.uid});
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 80),
                                  transitionsBuilder: ((context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child,)),
                                  pageBuilder: ((context, animation, secondaryAnimation) => SplashScreen())));
                          }).onError((error, stackTrace) {
                            print("Error ${error.toString()}");
                          });
                        })
                      ],
                    )))));
  }
}

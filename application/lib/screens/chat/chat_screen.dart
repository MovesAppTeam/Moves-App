import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/Signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _testingTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: reusableTextField("Search", Icons.search, false, _testingTextController, () {},),
          backgroundColor: Colors.grey.shade100,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.shade100,
          child: SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(),
          )),
        ));
  }
}

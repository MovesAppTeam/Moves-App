import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {

  print("hello world");
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Hello World")
          )
        )
      )
    );

  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

}


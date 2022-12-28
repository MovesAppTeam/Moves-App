import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/organization/create_organization.dart';
import 'package:application/screens/signin_screen.dart';
import 'package:application/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Text("Explore", style: Theme.of(context).textTheme.headline6),
          backgroundColor: Colors.teal,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CreateOrg()));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.black26;
                    }
                    return hexStringToColor('FD8A8A');
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
              child: const Text(
                'Create Organization',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            )));
  }
}

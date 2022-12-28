import 'package:application/screens/organization/create_organization.dart';
import 'package:application/screens/signin_screen.dart';
import 'package:application/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrgs extends StatefulWidget {
  const MyOrgs({super.key});

  @override
  State<MyOrgs> createState() => _MyOrgsState();
}

class _MyOrgsState extends State<MyOrgs> {
  final db = FirebaseFirestore.instance.collection("userList");
  final user = FirebaseAuth.instance.currentUser;
  late Future<DocumentSnapshot<Map<String, dynamic>>> myOrgs =
      db.doc(user!.displayName).get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: true,
          title: Text("My Organizations",
              style: Theme.of(context).textTheme.headline6),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: myOrgs,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final about = snapshot.data!.data();
                    if (about!.containsKey("myOrgs")) {
                      final List data = about["myOrgs"];
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: data.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 70,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                      )
                                    ]),
                                child: Stack(
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(data[index],
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold)))
                                  ],
                                )),
                          );
                        }),
                      );
                    }
                  }
                  return const Text("The was a problem displaying bio");
                }),
              ),
            ),
          ],
        )));
  }
}

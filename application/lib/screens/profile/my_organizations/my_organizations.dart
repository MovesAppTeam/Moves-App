import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/organization/create_organization.dart';
import 'package:application/screens/organization/organization_view.dart';
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
      db.doc(user!.uid).get();
  TextEditingController _testingTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.black,
          title: Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 20, 10),
              child: Stack(
                children: [
                  reusableTextField(
                      "Search orgnaization",
                      Icons.search,
                      false,
                      _testingTextController,
                      () {
                        setState(() {
                          
                        });
                      },
                      Colors.black,
                      Colors.black,
                      Colors.grey.shade100),
                ],
              )),
          backgroundColor: Colors.grey.shade100,
          leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new, // add custom icons also
          ),
        ),
        actions: <Widget>[
          
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.more_vert),
              )),
        ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey.shade100,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Divider(),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration:
                      BoxDecoration(),
                  child: TextButton(onPressed: () {
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateOrg()));
                  },
                  
                    child: const Text(
                      'Create Organization',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),)),
              Divider(),
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
                            if (data[index].toString().toLowerCase().startsWith(_testingTextController.text.toLowerCase())) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.all(0),), shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)))),
                                  onPressed: () {
                                    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrgView(title: data[index],)));
                                  },
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
                                                    fontWeight:
                                                        FontWeight.bold)))
                                      ],
                                    )),)
                              );
                            } else {
                              return const SizedBox(height: 0, width: 0,);
                            }
                          }),
                        );
                      }
                    }
                    return const Text("The was a problem displaying bio");
                  }),
                ),
              ),
            ],
          )),
        
        ));
  }
}

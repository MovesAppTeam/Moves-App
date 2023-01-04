import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/profile/my_organizations/my_organizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class OrgView extends StatefulWidget {
  const OrgView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<OrgView> createState() => _OrgViewState();
}

class _OrgViewState extends State<OrgView> {
  TextEditingController _titleTextController = TextEditingController();
  bool createOrg = false;
  SampleItem? selectedMenu;
  late String title = widget.title;
  late final data =
      FirebaseFirestore.instance.collection("Organizations").doc(title).get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        automaticallyImplyLeading: true,
        centerTitle: true,
        foregroundColor: Colors.black,
        title: Text(widget.title),
        backgroundColor: Colors.grey.shade100,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new, // add custom icons also
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: PopupMenuButton<SampleItem>(
              initialValue: selectedMenu,
              // Callback that sets the selected popup menu item.
              onSelected: (SampleItem item) {
                setState(() {
                  selectedMenu = item;
                });
              },
              child: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SampleItem>>[
                PopupMenuItem<SampleItem>(
                    value: SampleItem.itemOne,
                    onTap: (() {
                      createOrg = !createOrg;
                      print(createOrg);
                    }),
                    child: const Text('Create Organization')),
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemTwo,
                  child: Text('Item 2'),
                ),
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemThree,
                  child: Text('Item 3'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final orgData = snapshot.data!.data();
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey.shade100,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.02, 20, 0),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(children: [
                    profileImage(
                          context,
                          orgData!["imagePath"] ?? "assets/solo-cup-logo.png",
                          false),
                    const SizedBox(height: 20),
                    Text(
                        orgData['bio'],
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                    ),
                  ]),
                      ),
                      createOrg?
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.greenAccent[100],
          child: SizedBox(
            width: 300,
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  
                  Row(children: [
                    Icon(Icons.clear)
                  ],),
                  const SizedBox(
                    height: 10,
                  ), 
                  reusableTextFieldnoIcon("Title", _titleTextController, Colors.white.withOpacity(0.9), Colors.black.withOpacity(0.3)),
                  
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  const Text(
                    'GeeksforGeeks is a computer science portal for geeks at geeksforgeeks.org. It contains well written, well thought and well explained computer science and programming articles, quizzes, projects, interview experiences and much more!!',
                    style: TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                    ), //Textstyle
                  ), //Text
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  SizedBox(
                    width: 100,
 
                    child: ElevatedButton(
                          onPressed: () => 'Null',
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green)),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Center(
                              child: Row(
                                children: const [
                                  Icon(Icons.touch_app),
                                  Text('Done')
                                ],
                              ),
                            ),
                          ),
                    ),
                    // RaisedButton is deprecated and should not be used
                    // Use ElevatedButton instead
 
                    // child: RaisedButton(
                    //   onPressed: () => null,
                    //   color: Colors.green,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(4.0),
                    //     child: Row(
                    //       children: const [
                    //         Icon(Icons.touch_app),
                    //         Text('Visit'),
                    //       ],
                    //     ), //Row
                    //   ), //Padding
                    // ), //RaisedButton
                  ) //SizedBox
                ],
              ), //Column
            ), //Padding
          ), //SizedBox
        ),
                        ),
                        ),
                      ) : SizedBox(height: 0, width: 0,)]),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

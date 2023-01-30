import 'dart:io';

import 'package:application/data_class/events_data.dart';
import 'package:application/data_class/organization_class.dart';
import 'package:application/screens/bottom_navigation.dart';
import 'package:application/screens/explore/explore_screen.dart';
import 'package:application/screens/profile/my_organizations/my_organizations.dart';
import 'package:application/utils/color_utils.dart';
import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class CreateOrg extends StatefulWidget {
  const CreateOrg({super.key});

  @override
  State<CreateOrg> createState() => _CreateOrgState();
}

class _CreateOrgState extends State<CreateOrg> {
  @override
  void dispose() {
    super.dispose();
  }

  final db = FirebaseFirestore.instance.collection("Organizations");
  final userOrgData = FirebaseFirestore.instance.collection("userList");
  final user = FirebaseAuth.instance.currentUser;
  Organization? org;
  Map<String, dynamic>? userOrgMap;
  late List _userList = [];
  final List _admins = [];
  final List _managers = [];
  final List _members = [];
  final List _allMembers = [];
  final List<Event> _events = [];
  late String _privacy;
  String? _img;
  bool _public_check = false;
  bool _hidden = false;
  bool _private = false;
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _bioTextController = TextEditingController();
  late String image_url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Create Organization",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.black87),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: [
                Stack(children: [
                  profileImage(
                      context, _img ?? "assets/solo-cup-logo.png", true, 100, 100),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white.withOpacity(0.8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.create_outlined,
                            size: 20, color: Colors.black.withOpacity(0.5)),
                        onPressed: () async {
                          print("Image picker pressed");
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          File imageFile = File(image!.path);
                          String fileName = imageFile.path;
                          if (image != null) {
                            _img = image.path;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  )
                ]),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                reusableTextFieldnoIcon(
                    "Enter Org Name",
                    _nameTextController,
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.3)),
                const SizedBox(height: 20),
                const Text("Privacy Setting",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 20),
                settingsCheckBox(_public_check, 'Public',
                    'Anyone will be able to see and search for this organization',
                    (value) {
                  setState(() {
                    _privacy = "Public";
                    _public_check = value!;
                    _private = false;
                    _hidden = false;
                  });
                }),
                const SizedBox(height: 10),
                settingsCheckBox(_private, 'Private',
                    'Only friends will be able to see and search for this organization',
                    (value) {
                  setState(() {
                    _privacy = "Private";
                    _private = value!;
                    _public_check = false;
                    _hidden = false;
                  });
                }),
                const SizedBox(height: 10),
                settingsCheckBox(_hidden, 'Hidden',
                    'Only you and Org members will be able to see and search for this organization',
                    (value) {
                  setState(() {
                    _privacy = "Hidden";
                    _hidden = value!;
                    _public_check = false;
                    _private = false;
                  });
                }),
                TextField(
                  controller: _bioTextController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    labelText: 'About',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // <-- SEE HERE
                ),
                const SizedBox(height: 10),
                defaultButton(context, 'Done', hexStringToColor("FFE9A0"), 200,
                    () async {
                  _admins.add(user!.uid);
                  _allMembers.add(user!.uid);
                  org = Organization(
                      id: uuid.v4(),
                      imagePath: _img ?? "assets/solo-cup-logo.png",
                      name: _nameTextController.text,
                      adminList: _admins,
                      managerList: _managers,
                      members: _members,
                      totalMembers: _allMembers,
                      events: _events,
                      privacy: _privacy,
                      bio: _bioTextController.text,
                      popScore: 0);
                  db.doc(_nameTextController.text).set(org!.toMap());
                  userOrgData.doc(user!.uid).get().then((value) {
                    userOrgMap = value.data();
                    _userList = userOrgMap!.putIfAbsent("myOrgs", () => null);
                    _userList.add(_nameTextController.text);
                    userOrgData.doc(user!.uid).update({"myOrgs": _userList});
                  });
                  if (org!.imagePath.contains('assets')) {
                    setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNav(
                                  page: 4,
                                )));
                  } else {
                    FirebaseStorage storage = FirebaseStorage.instance;
                    Reference ref = storage
                        .ref(org!.name)
                        .child("OrgProfileImage-${org!.name}");

                    UploadTask uploadTask = ref.putFile(File(org!.imagePath));
                    await uploadTask.whenComplete(() async {
                      var url = await ref.getDownloadURL();
                      image_url = url.toString();

                      Map<String, dynamic> demodata = {"image_url": image_url};
                      CollectionReference collectionreference =
                          FirebaseFirestore.instance
                              .collection("Organizations");
                      collectionreference
                          .doc(org!.name)
                          .update({"imagePath": image_url}).then((value) {
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNav(
                                      page: 4,
                                    )));
                      });
                    });
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

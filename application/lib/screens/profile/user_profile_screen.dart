import 'dart:async';
import 'dart:io';

import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/Signin_screen.dart';
import 'package:application/screens/bottom_navigation.dart';
import 'package:application/screens/profile/edit_profile_screen.dart';
import 'package:application/screens/profile/my_organizations/my_organizations.dart';
import 'package:application/screens/profile/settings/settings.dart';
import 'package:application/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final XFile? image;
    late final myOrgList;
    final db = FirebaseFirestore.instance.collection("userList");
    final storage = FirebaseStorage.instance;
    final user = FirebaseAuth.instance.currentUser;

    late Future<DocumentSnapshot<Map<String, dynamic>>>? bio =
        db.doc(user!.uid).get();
    late String image_url;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Text("Profile", style: Theme.of(context).textTheme.headline6),
          backgroundColor: Colors.teal,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.shade100,
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.08, 20, 0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          profileImage(context,
                              user!.photoURL ?? "assets/solo-cup-logo.png"),
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
                                    size: 20,
                                    color: Colors.black.withOpacity(0.5)),
                                onPressed: () async {
                                  print("Image picker pressed");
                                  image = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (image != null) {
                                    try {
                                      var imageFile = File(image!.path);
                                      String fileName = imageFile.path;
                                      FirebaseStorage storage =
                                          FirebaseStorage.instance;
                                      Reference ref = storage
                                          .ref(user.uid)
                                          .child("ProfileImage-${user.uid}");

                                      UploadTask uploadTask =
                                          ref.putFile(imageFile);
                                      await uploadTask.whenComplete(() async {
                                        var url = await ref.getDownloadURL();
                                        image_url = url.toString();

                                        Map<String, dynamic> demodata = {
                                          "image_url": image_url
                                        };
                                        CollectionReference
                                            collectionreference =
                                            FirebaseFirestore.instance
                                                .collection("userList");
                                        collectionreference
                                            .doc(user.uid)
                                            .update({"imagePath": demodata});
                                      }).catchError((onError) {
                                        print(onError);
                                      });
                                    } catch (error) {
                                      print(error);
                                    }

                                    user
                                        .updatePhotoURL(image_url)
                                        .then((value) {
                                      FirebaseAuth.instance.currentUser!
                                          .reload()
                                          .then((value) {
                                        setState(() {});
                                      });
                                    });
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(user.displayName ?? "Name",
                          style: Theme.of(context).textTheme.headline4),
                      Text(user.email ?? "Email",
                          style: Theme.of(context).textTheme.bodyText2),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                          future: bio,
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              final about = snapshot.data!.data();
                              if (about!.containsKey("about")) {
                                return Text(about["about"]);
                              }
                            }
                            return const Text("");
                          })),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditProfile()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: hexStringToColor("FFE9A0"),
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text("Edit Profile",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      ProfileListItem(
                        title: "My Organizations",
                        icon: Icons.assignment_outlined,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyOrgs()));
                        },
                      ),
                      ProfileListItem(
                        title: "Settings",
                        icon: Icons.settings_outlined,
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SettingsScreen()));
                        },
                      ),
                      ProfileListItem(
                        title: "Log Out",
                        icon: Icons.web_asset_off_outlined,
                        textColor: Colors.black,
                        onPress: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            print("Signed Out");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                          });
                        },
                      ),
                    ],
                  )),
            )));
  }
}

class ProfileListItem extends StatelessWidget {
  const ProfileListItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.black.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: Colors.black87,
          )),
      title: Text(title,
          style:
              Theme.of(context).textTheme.bodyText1?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Icon(Icons.chevron_right,
                  size: 18, color: Colors.black.withOpacity(0.5)),
            )
          : null,
    );
  }
}

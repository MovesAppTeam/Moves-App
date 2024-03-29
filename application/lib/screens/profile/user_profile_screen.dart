import 'dart:async';
import 'dart:io';

import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/Signin_screen.dart';
import 'package:application/screens/bottom_navigation.dart';
import 'package:application/screens/organization/organization_view.dart';
import 'package:application/screens/profile/edit_profile_screen.dart';
import 'package:application/screens/profile/friends/friends.dart';
import 'package:application/screens/profile/my_organizations/my_organizations.dart';
import 'package:application/screens/profile/settings/settings.dart';
import 'package:application/screens/signup_screen.dart';
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
    final int friends = 0;
    final int movePoints = 0;
    final int orgNum = 0;

    late int socialIndex;
    final user = FirebaseAuth.instance.currentUser;
    late final XFile? image;
    late final myOrgList;
    final db = FirebaseFirestore.instance.collection("userList");
    final storage = FirebaseStorage.instance;

    late Future<DocumentSnapshot<Map<String, dynamic>>>? userData =
        db.doc(user!.uid).get();
    late String image_url;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Text("Profile", style: Theme.of(context).textTheme.headline6),
          backgroundColor: Colors.grey.shade100,
          leading: GestureDetector(
            onTap: () {/* Write listener code here */},
            child: const Icon(
              Icons.menu, // add custom icons also
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                )),
          ],
        ),
        body: FutureBuilder(
          future: userData,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final thisUser = snapshot.data!.data();
              

              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey.shade100,
                  child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(20,
                            MediaQuery.of(context).size.height * 0.08, 20, 0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                profileImage(
                                    context,
                                    user!.photoURL ??
                                        "assets/solo-cup-logo.png",
                                    false, 100, 100),
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
                                        image = await ImagePicker().pickImage(
                                            source: ImageSource.gallery);
                                        if (image != null) {
                                          try {
                                            var imageFile = File(image!.path);
                                            String fileName = imageFile.path;
                                            FirebaseStorage storage =
                                                FirebaseStorage.instance;
                                            Reference ref = storage
                                                .ref(user.uid)
                                                .child(
                                                    "ProfileImage-${user.uid}");

                                            UploadTask uploadTask =
                                                ref.putFile(imageFile);
                                            await uploadTask
                                                .whenComplete(() async {
                                              var url =
                                                  await ref.getDownloadURL();
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
                                                  .update(
                                                      {"imagePath": demodata});
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
                            Text(thisUser!["about"]),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const FriendsList()));
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        '${thisUser['numFriends']}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Friends',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                
                                Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Column(
                                    children: [
                                      Text(
                                        '${thisUser['numOrgs']}',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Orgs',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
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
                                          builder: (context) =>
                                              const EditProfile()));
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
                                    context, createRoute(const MyOrgs()));
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
                                      PageRouteBuilder(
                                          transitionDuration:
                                              Duration(milliseconds: 100),
                                          transitionsBuilder: ((context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) =>
                                              FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              )),
                                          pageBuilder: ((context, animation,
                                                  secondaryAnimation) =>
                                              SignInScreen())));
                                });
                              },
                            ),
                          ],
                        )),
                  ));
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(
                child: Text("Data refused to load"),
              );
            }
          }),
        ));
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

import 'package:application/screens/Signin_screen.dart';
import 'package:application/screens/bottom_navigation.dart';
import 'package:application/screens/profile/edit_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:application/utils/color_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Profile", style: Theme.of(context).textTheme.headline4),
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
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                  image: AssetImage(user!.photoURL ??
                                      "assets/solo-cup-logo.png"),
                                )),
                          ),
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
                                  final image = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  user
                                      .updatePhotoURL(image?.path)
                                      .then((value) {
                                    FirebaseAuth.instance.currentUser!.reload().then((value) {
                                    Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const BottomNav()))
                                        .then((value) {
                                      setState() {
                                        user.photoURL == image?.path;
                                      }
                                    });
                                  });
                                  });
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
                        onPress: () {},
                      ),
                      ProfileListItem(
                        title: "Settings",
                        icon: Icons.settings_outlined,
                        onPress: () {},
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
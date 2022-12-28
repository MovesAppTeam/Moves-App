import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/bottom_navigation.dart';
import 'package:application/screens/profile/user_profile_screen.dart';
import 'package:application/utils/color_utils.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final db = FirebaseFirestore.instance.collection("userList");
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _bioTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget okButton;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: true,
        title:
            Text("Edit Profile", style: Theme.of(context).textTheme.headline6),
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
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          print("Image picker pressed");
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            user!.updatePhotoURL(image.path).then((value) {
                              FirebaseAuth.instance.currentUser!
                                  .reload()
                                  .then((value) {
                                setState(() {});
                              });
                            });
                          }
                        },
                        child: Text(
                          "Edit display photo",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .apply(color: Colors.red.shade400),
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      editProfileListItem(context, _usernameTextController,
                          "Username", user!.displayName, false, false, false),
                      const SizedBox(
                        height: 20,
                      ),
                      editProfileListItem(context, _phoneTextController,
                          "Phone #", user!.phoneNumber, false, true, false),
                      const SizedBox(
                        height: 20,
                      ),
                      editProfileListItem(context, _emailTextController,
                          "Email", user!.email, false, false, true),
                      const SizedBox(
                        height: 20,
                      ),
                      editProfileListItem(context, _bioTextController, "Bio",
                          "Bio", true, false, false),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_usernameTextController.text == "") {
                              _usernameTextController.text = user!.displayName!;
                            }
                            if (_emailTextController.text == "") {
                              _emailTextController.text = user!.email!;
                            }
                            try {
                              await user!
                                  .updateDisplayName(
                                      _usernameTextController.text)
                                  .then((value) {
                                FirebaseAuth.instance.currentUser!.reload();
                              });
                              if (EmailValidator.validate(
                                      _emailTextController.text) ==
                                  false) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  /// need to set following properties for best effect of awesome_snackbar_content
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'On Snap!',
                                    message: "That email is not valid!",

                                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                    contentType: ContentType.failure,
                                  ),
                                ));
                              } else {
                                (user!.email != _emailTextController.text)
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Enter Password to change Email"),
                                            content: TextField(
                                              controller:
                                                  _passwordTextController,
                                              obscureText: true,
                                              enableSuggestions: false,
                                              autofocus: false,
                                              autocorrect: false,
                                              cursorColor: Colors.black,
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.9)),
                                              decoration: InputDecoration(
                                                labelText: "Password",
                                                labelStyle: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.9)),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                              ),
                                              keyboardType: TextInputType.name,
                                              minLines: 1,
                                              maxLines: 1,
                                              onChanged: (value) {
                                                TextSelection
                                                    previousSelection =
                                                    _passwordTextController
                                                        .selection;
                                                _passwordTextController.text =
                                                    value;
                                                _passwordTextController
                                                        .selection =
                                                    previousSelection;
                                              },
                                            ),
                                            actions: [
                                              okButton = TextButton(
                                                child: Text("OK"),
                                                onPressed: () async {
                                                  AuthCredential credential =
                                                      EmailAuthProvider.credential(
                                                          email: user!.email!,
                                                          password:
                                                              _passwordTextController
                                                                  .text);
                                                  await FirebaseAuth
                                                      .instance.currentUser!
                                                      .reauthenticateWithCredential(
                                                          credential)
                                                      .onError(
                                                          (error, stackTrace) {
                                                    // ignore: todo
                                                    // TODO: do something if password is wrong
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      /// need to set following properties for best effect of awesome_snackbar_content
                                                      elevation: 0,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      content:
                                                          AwesomeSnackbarContent(
                                                        title: 'On Snap!',
                                                        message:
                                                            "Incorrect Password! Try again.",

                                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                        contentType:
                                                            ContentType.failure,
                                                      ),
                                                    ));
                                                    throw NullThrownError();
                                                  }).then((value) async {
                                                    await user!
                                                        .updateEmail(
                                                            _emailTextController
                                                                .text)
                                                        .then((value) {
                                                      FirebaseAuth
                                                          .instance.currentUser!
                                                          .reload()
                                                          .then((value) {
                                                        if (_bioTextController
                                                                .text !=
                                                            "") {
                                                          db
                                                              .doc(user!
                                                                  .displayName)
                                                              .update({
                                                            "bio":
                                                                _bioTextController
                                                                    .text
                                                          });
                                                        }
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const BottomNav()));
                                                      });
                                                    });
                                                  });
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      )
                                    : FirebaseAuth.instance.currentUser!
                                        .reload()
                                        .then((value) {
                                        if (_bioTextController.text != "") {
                                          db.doc(user!.displayName).update(
                                              {"bio": _bioTextController.text});
                                        }
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const BottomNav()));
                                      });

                                //TODO: update user phone number
                              }
                            } catch (error) {
                              print(error);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: hexStringToColor("FFE9A0"),
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text("Done",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  )))),
    );
  }
}

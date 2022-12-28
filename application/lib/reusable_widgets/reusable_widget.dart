import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

Image logoWidget(String imagename) {
  return Image.asset(
    imagename,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress);
}

TextField reusableTextFieldnoIcon(
    String text, TextEditingController controller) {
  return TextField(
      textAlign: TextAlign.center,
      controller: controller,
      obscureText: false,
      enableSuggestions: true,
      autocorrect: true,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
      decoration: InputDecoration(
        label: Center(child: Text(text)),
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      keyboardType: TextInputType.name);
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
        child: Text(
          isLogin ? 'LOG IN' : 'SIGN UP',
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ));
}

Container defaultButton(
    BuildContext context, String label, Color buttonColor, double? width, Function onTap) {
  return Container(
      width: width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(45)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return buttonColor;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)))),
        child: Text( label,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ));
}

String imgRandom() {
  var imgList = [
    "smiley-1635449__480.png",
    "man-303792__480.png",
    "hijab-2272708__480.webp",
    "businessman-310819__480.webp",
    "avatar-1300331__480.webp",
    "avatar-1295773__480.png",
    "8.jpg",
    "7.jpg",
    "6.jpg"
        "5.jpg"
        "4.jpg"
        "3.jpg"
        "2.jpg"
        "1.jpg"
        "0.jpg"
  ];
  int min = 0;
  int max = imgList.length - 1;
  Random rnd = new Random();
  int r = min + rnd.nextInt(max - min);
  return imgList[r].toString();
}

Widget editProfileListItem(BuildContext context, TextEditingController controller,
    String text, String? placeholder, bool isBio, bool isPhone, bool isEmail) {
  return !isBio
      ? Row(
          children: <Widget>[
            SizedBox(
                height: 25, child: Text(text, style: TextStyle(fontSize: 18))),
            const SizedBox(
              width: 12,
            ),
            Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 30,
                  child: TextField(
                    controller: controller,
                    obscureText: false,
                    enableSuggestions: false,
                    autofocus: false,
                    focusNode: FocusNode(),
                    autocorrect: false,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black.withOpacity(0.9)),
                    decoration: InputDecoration(
                      labelText: placeholder ?? "",
                      labelStyle:
                          TextStyle(color: Colors.black.withOpacity(0.9)),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    keyboardType: !isPhone
                        ? !isEmail
                            ? TextInputType.multiline
                            : TextInputType.emailAddress
                        : TextInputType.number,
                    minLines: 1,
                    maxLines: !isBio ? 1 : null,
                    onChanged: (value) {
                      TextSelection previousSelection = controller.selection;
                      controller.text = value;
                      controller.selection = previousSelection;
                    },
                  ),
                ))
          ],
        )
      : TextField(
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          obscureText: false,
          enableSuggestions: false,
          autofocus: false,
          autocorrect: false,
          cursorColor: Colors.black,
          style: TextStyle(color: Colors.black.withOpacity(0.9)),
          decoration: InputDecoration(
            labelText: placeholder ?? "",
            labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          keyboardType: !isPhone
              ? !isEmail
                  ? TextInputType.multiline
                  : TextInputType.emailAddress
              : TextInputType.number,
          minLines: 1,
          maxLines: !isBio ? 1 : null,
          onChanged: (value) {
            TextSelection previousSelection = controller.selection;
            controller.text = value;
            controller.selection = previousSelection;
          },
        );
}

Future pickImg() async {
  final user = FirebaseAuth.instance.currentUser;
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageTemp = File(image.path);

    return image.path;
  } catch (error) {
    print(error);
  }
}

Container profileImage(BuildContext context, String imageURL) {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          blurRadius: 8,
          spreadRadius: 6,
        ),
      ],
    ),
    child: SizedBox(
      width: 100,
      height: 100,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image(
            image: AssetImage(imageURL),
          )),
    ),
  );
}

SizedBox settingsCheckBox(
    bool isChecked, String title, String caption, Function(bool?)? onChange) {
  return SizedBox(
    width: 400,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent),
              borderRadius: BorderRadius.circular(20),
            ), //BoxDecoration

            /** CheckboxListTile Widget **/
            child: Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.white, // Your color
              ),
              child: CheckboxListTile(
                title: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  caption,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                autofocus: false,
                activeColor: Colors.white,
                checkColor: Colors.black,
                selected: isChecked,
                value: isChecked,
                onChanged: onChange,
              ),
            ) //CheckboxListTile
            ), //Container
      ), //Padding
    ), //Center
  );
}



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

Row editProfileListItem(BuildContext context, TextEditingController controller,
    String text, String? placeholder, bool isBio, bool isPhone, bool isEmail) {
  return Row(
    children: <Widget>[
      Text(text, style: TextStyle(fontSize: 18)),
      const SizedBox(
        width: 12,
      ),
      Flexible(
          child: SizedBox(
        height: 30,
        child: TextField(
          controller: controller,
          obscureText: false,
          enableSuggestions: false,
          autofocus: true,
          autocorrect: false,
          cursorColor: Colors.black,
          style: TextStyle(color: Colors.black.withOpacity(0.9)),
          decoration: InputDecoration(
            labelText: placeholder ?? "",
            labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          keyboardType: !isPhone ? !isEmail ? TextInputType.multiline : TextInputType.emailAddress : TextInputType.number,
          minLines: 1,
          maxLines: !isBio ? 1 : 1,
          onChanged: (value) {
            TextSelection previousSelection = controller.selection;
            controller.text = value;
            controller.selection = previousSelection;
          },
        ),
      ))
    ],
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

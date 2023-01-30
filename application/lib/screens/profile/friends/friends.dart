import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  TextEditingController _testingTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: true,
          title: Text("Friends", style: Theme.of(context).textTheme.headline6),
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black,
          
          
        ),
        body: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
                controller: _testingTextController,
                obscureText: false,
                enableSuggestions: true,
                onChanged: (value) {
            setState(() {
                              
                            });
                },
                autocorrect: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            labelText: 'Search',
            labelStyle: TextStyle(color: Colors.white),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.black45,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
                ),
                keyboardType: false
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress),
          ),
        )
    );
  }
}

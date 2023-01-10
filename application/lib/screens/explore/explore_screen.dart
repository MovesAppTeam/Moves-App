import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/organization/create_organization.dart';
import 'package:application/screens/signin_screen.dart';
import 'package:application/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Text("Explore", style: Theme.of(context).textTheme.headline6),
          backgroundColor: Colors.grey.shade100,
        ),
        body: Center(
            child: ElevatedButton(
                child: const Text("LOGOUT"),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    print("Signed Out");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  });
                })));
  }
}

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
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Text("Explore", style: Theme.of(context).textTheme.headline6),
          backgroundColor: Colors.teal,
        ),
        body: PaginatedSearchBar<Text>(
          maxHeight: 300,
          hintText: 'Search',
          headerBuilderState:
              PaginatedSearchBarBuilderStateProperty.empty((context) {
            return const Center(
              child: Text(
                  "Explore page is empty"),
            );
          }),
          emptyBuilder: (context) {
            return const Text("I'm an empty state!");
          },
          onSearch: ({
            required pageIndex,
            required pageSize,
            required searchQuery,
          }) async {
            // Call your search API to return a list of items
            return [Text("item1")];
          },
          itemBuilder: (
            context, {
            required item,
            required index,
          }) {
            return Text("item1");
          },
        ));
  }
}

import 'dart:io';

import 'package:application/data_class/events_data.dart';
import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/organization/create_organization.dart';
import 'package:application/screens/profile/my_organizations/my_organizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:place_picker/place_picker.dart';
import 'package:group_button/group_button.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class OrgView extends StatefulWidget {
  const OrgView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<OrgView> createState() => _OrgViewState();
}

class _OrgViewState extends State<OrgView> {
  final db = FirebaseFirestore.instance.collection("userList");
  final user = FirebaseAuth.instance.currentUser;
  String address = "Edit address";
  late Widget okButton;
  late TimeOfDay start;
  late TimeOfDay end;
  DateTime goodDate = DateTime.now();
  bool isaddressInput = false;
  late List fileType;
  late List orgMembers;
  late String _extension;
  late FileType _pickingType;
  String textValue = 'Public';
  bool isPrivate = false;
  bool _tapped = false;
  bool _address = false;
  FilePickerResult? result = null;
  late File file;
  late String filePath;
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  bool createOrg = false;
  SampleItem? selectedMenu;
  late String title = widget.title;
  late Map<String, dynamic>? userEventMap;
  late List _userList = [];
  late List _orgList = [];
  late final orgDB =
      FirebaseFirestore.instance.collection("Organizations").doc(title);
  late final data =
      FirebaseFirestore.instance.collection("Organizations").doc(title).get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        automaticallyImplyLeading: true,
        centerTitle: true,
        foregroundColor: Colors.black,
        title: Text(widget.title),
        backgroundColor: Colors.grey.shade100,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new, // add custom icons also
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: PopupMenuButton<SampleItem>(
              initialValue: selectedMenu,
              // Callback that sets the selected popup menu item.
              onSelected: (SampleItem item) {
                setState(() {
                  selectedMenu = item;
                });
              },
              child: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<SampleItem>>[
                PopupMenuItem<SampleItem>(
                    value: SampleItem.itemOne,
                    onTap: (() {
                      createOrg = !createOrg;
                      start = TimeOfDay.now();
                      end = TimeOfDay.now();
                      print(createOrg);
                    }),
                    child: const Text('Create Event')),
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemTwo,
                  child: Text('Item 2'),
                ),
                const PopupMenuItem<SampleItem>(
                  value: SampleItem.itemThree,
                  child: Text('Item 3'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final orgData = snapshot.data!.data();
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey.shade100,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.02, 20, 0),
                  child: Stack(children: [
                    Center(
                      child: Column(children: [
                        profileImage(
                            context,
                            orgData!["imagePath"] ?? "assets/solo-cup-logo.png",
                            false),
                        const SizedBox(height: 20),
                        Text(
                          orgData['bio'],
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ]),
                    ),
                    createOrg
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 50,
                                  shadowColor: Colors.black,
                                  color: Colors.greenAccent[100],
                                  child: SizedBox(
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    createOrg = !createOrg;

                                                    _titleTextController.text =
                                                        "";
                                                    _descriptionTextController
                                                        .text = "";
                                                    toggleSwitch(true);
                                                    result = null;

                                                    setState(() {});
                                                  },
                                                  icon:
                                                      const Icon(Icons.clear)),
                                              const Spacer(),
                                              const Text(
                                                "Create Event",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              const Spacer(),
                                              const Spacer(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          reusableTextFieldnoIcon(
                                              "Title",
                                              _titleTextController,
                                              Colors.white.withOpacity(0.9),
                                              Colors.black.withOpacity(0.3)),

                                          const SizedBox(
                                            height: 10,
                                          ), //SizedBox
                                          TextField(
                                            controller:
                                                _descriptionTextController,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            cursorColor: Colors.black,
                                            decoration: const InputDecoration(
                                              labelText: 'Description',
                                              labelStyle: TextStyle(
                                                  color: Colors.black54),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          const Text(
                                            "Address:",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          RadioListTile(
                                            value: _tapped,
                                            groupValue: true,
                                            toggleable: true,
                                            onChanged: (value) {
                                              _tapped = !_tapped;
                                              address = "Edit address";
                                              setState(() {});
                                            },
                                            title: const Text(
                                                "Address recieved upon direct message",
                                                style: TextStyle(fontSize: 14)),
                                          ),
                                          !_tapped
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        width: (address ==
                                                                "Edit address")
                                                            ? 100
                                                            : 200,
                                                        child: Text(address)),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    const Icon(Icons.create)
                                                  ],
                                                )
                                              : const SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          DatePicker(DateTime.now(),
                                              initialSelectedDate:
                                                  DateTime.now(),
                                              selectionColor: Colors.black,
                                              selectedTextColor: Colors.white,
                                              onDateChange: (date) {
                                            // New date selected
                                            setState(() {
                                              goodDate = date;
                                            });
                                            print(date);
                                          }),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              const Spacer(),
                                              const Text(
                                                "Start:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: ((context) {
                                                        return (AlertDialog(
                                                          title: const Text(
                                                              "Set start time"),
                                                          actions: [
                                                            okButton =
                                                                TextButton(
                                                              child: const Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            )
                                                          ],
                                                          content:
                                                              TimePickerSpinner(
                                                            minutesInterval: 15,
                                                            is24HourMode: false,
                                                            normalTextStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .black26),
                                                            highlightedTextStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .black),
                                                            spacing: 25,
                                                            itemHeight: 60,
                                                            isForce2Digits:
                                                                true,
                                                            onTimeChange:
                                                                (time) {
                                                              setState(() {
                                                                start = TimeOfDay
                                                                    .fromDateTime(
                                                                        time);
                                                              });
                                                            },
                                                          ),
                                                        ));
                                                      }));
                                                },
                                                child: Text(
                                                    "${start.format(context)}"),
                                              ),
                                              const Spacer(),
                                              const Text(
                                                "End:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: ((context) {
                                                        return (AlertDialog(
                                                          title: const Text(
                                                              "Set end time"),
                                                          actions: [
                                                            okButton =
                                                                TextButton(
                                                              child: const Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            )
                                                          ],
                                                          content:
                                                              TimePickerSpinner(
                                                            minutesInterval: 15,
                                                            is24HourMode: false,
                                                            normalTextStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .black26),
                                                            highlightedTextStyle:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .black),
                                                            spacing: 25,
                                                            itemHeight: 60,
                                                            isForce2Digits:
                                                                true,
                                                            onTimeChange:
                                                                (time) {
                                                              setState(() {
                                                                end = TimeOfDay
                                                                    .fromDateTime(
                                                                        time);
                                                              });
                                                            },
                                                          ),
                                                        ));
                                                      }));
                                                },
                                                child: Text(
                                                    "${end.format(context)}"),
                                              ),
                                              const Spacer(),
                                              const Spacer(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Privacy:",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 0, 0),
                                                child: Text(
                                                  textValue,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Switch(
                                                onChanged: toggleSwitch,
                                                value: isPrivate,
                                                activeColor: Colors.blue,
                                                activeTrackColor: Colors.yellow,
                                                inactiveThumbColor:
                                                    Colors.redAccent,
                                                inactiveTrackColor:
                                                    Colors.orange,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              print("File picker pressed");
                                              result = await FilePicker.platform
                                                  .pickFiles();

                                              if (result != null) {
                                                filePath = result!
                                                    .files.single.path
                                                    .toString();
                                                file = File(filePath);
                                                fileType = filePath.split('.');
                                              } else {
                                                // User canceled the picker
                                              }
                                              setState(() {});
                                            },
                                            child: result != null
                                                ? Column(
                                                    children: [
                                                      SizedBox(
                                                          width: 180,
                                                          height: 200,
                                                          child: fileType
                                                                      .last ==
                                                                  "pdf"
                                                              ? SfPdfViewer
                                                                  .file(file)
                                                              : Image.file(
                                                                  file)),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    30,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            child: SizedBox(
                                                              width: 200,
                                                              child: Text(
                                                                result != null
                                                                    ? result!
                                                                        .files
                                                                        .single
                                                                        .name
                                                                    : "Upload a flyer",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyText2!
                                                                    .apply(
                                                                        color: Colors
                                                                            .red
                                                                            .shade400),
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                result = null;
                                                                setState(() {});
                                                              },
                                                              icon: const Icon(
                                                                Icons.cancel,
                                                                color: Colors
                                                                    .black87,
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    result != null
                                                        ? result!
                                                            .files.single.name
                                                        : "Upload a flyer",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .apply(
                                                            color: Colors
                                                                .red.shade400),
                                                  ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),

                                          SizedBox(
                                            width: 100,

                                            child: ElevatedButton(
                                              onPressed: () {
                                                final DateTime startTime =
                                                    DateTime(
                                                        goodDate.year,
                                                        goodDate.month,
                                                        goodDate.day,
                                                        start.hour,
                                                        start.minute);
                                                final DateTime endTime =
                                                    DateTime(
                                                        goodDate.year,
                                                        goodDate.month,
                                                        goodDate.day,
                                                        end.hour,
                                                        end.minute);
                                                final event = Event(
                                                    eventName:
                                                        _titleTextController
                                                            .text,
                                                    from: startTime,
                                                    to: endTime,
                                                    background: randomColor(),
                                                    isAllDay: false);
                                                setState(() {
                                                  _orgList =
                                                      orgData.putIfAbsent(
                                                          "events", () => null);
                                                  _orgList.add(event.toJson());
                                                  orgDB.update(
                                                      {"events": _orgList});
                                                  orgMembers =
                                                      orgData["totalMembers"];
                                                  for (var i = 0;
                                                      i < orgMembers.length;
                                                      i++) {
                                                    db
                                                        .doc(orgMembers[i])
                                                        .get()
                                                        .then((value) {
                                                      userEventMap =
                                                          value.data();
                                                      _userList = userEventMap!
                                                          .putIfAbsent("events",
                                                              () => null);
                                                      _userList
                                                          .add(event.toJson());
                                                      db
                                                          .doc(orgMembers[i])
                                                          .update({
                                                        "events": _userList
                                                      });
                                                    });
                                                  }

                                                  createOrg = !createOrg;
                                                });
                                              },
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.green)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Center(
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.touch_app),
                                                      Text('Done')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // RaisedButton is deprecated and should not be used
                                            // Use ElevatedButton instead

                                            // child: RaisedButton(
                                            //   onPressed: () => null,
                                            //   color: Colors.green,
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.all(4.0),
                                            //     child: Row(
                                            //       children: const [
                                            //         Icon(Icons.touch_app),
                                            //         Text('Visit'),
                                            //       ],
                                            //     ), //Row
                                            //   ), //Padding
                                            // ), //RaisedButton
                                          ) //SizedBox
                                        ],
                                      ), //Column
                                    ), //Padding
                                  ), //SizedBox
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          )
                  ]),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void toggleSwitch(bool value) {
    if (isPrivate == false) {
      setState(() {
        isPrivate = true;
        textValue = 'Private';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isPrivate = false;
        textValue = 'Public';
      });
      print('Switch Button is OFF');
    }
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyCQCmGoeJu9KoV-PDzro5fYnv-jLHYRVIc",
            )));

    // Handle the result in your way
    address = result.formattedAddress.toString();
    setState(() {});
  }
}

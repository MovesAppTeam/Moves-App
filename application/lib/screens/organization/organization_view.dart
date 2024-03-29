import 'dart:io';

import 'package:application/data_class/events_data.dart';
import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/organization/create_organization.dart';
import 'package:application/screens/profile/my_organizations/my_organizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:place_picker/place_picker.dart';
import 'package:group_button/group_button.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

enum SampleItem { itemOne, itemTwo, itemThree }

class OrgView extends StatefulWidget {
  const OrgView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<OrgView> createState() => _OrgViewState();
}

class _OrgViewState extends State<OrgView> {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final days = ['Sun', 'Mon', 'Tues', 'Wed', 'Thur', 'Fri', 'Sat'];
  late Event event;
  late String imageNeeded;
  String image_url = "";
  final db = FirebaseFirestore.instance.collection("userList");
  final FirebaseStorage storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser;
  String address = "Edit address";
  late double latitude;
  late double longitude;
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        automaticallyImplyLeading: true,
        centerTitle: true,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: data,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final orgData = snapshot.data!.data();

                  imageNeeded = orgData!['imagePath'];
                  return profileImage(context, imageNeeded, false, 30, 30);
                }
                return profileImage(
                    context, "assets/solo-cup-logo.png", false, 30, 30);
              }),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.title),
          ],
        ),
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
                      start = TimeOfDay.now();
                      end = TimeOfDay.now();
                      createOrg = !createOrg;
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
            List totalMembers = orgData!['totalMembers'];
            List eventList = orgData['events'];

            if (eventList != []) {
              eventList.sort();
              //event = Event.fromJson(eventList.last);
            }

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey.shade100,
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.02, 20, 0),
                  child: Stack(children: [
                    Center(
                      child: Column(children: [
                        /*profileImage(
                            context,
                            orgData!["imagePath"] ?? "assets/solo-cup-logo.png",
                            false,
                            100,
                            100),*/
                        const SizedBox(height: 20),
                        Text(
                          "   ${orgData['bio']}",
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Last Event:',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(width: 15),
                                eventList.length != 0
                                    ? Container(
                                        width: 55,
                                        height: 55,
                                        child: Column(
                                          children: [
                                            Text(months[event.from.month],
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text(event.from.day.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text(days[event.from.day],
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ],
                                        ),
                                      )
                                    : const Text(
                                        "No event has been created yet",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ))
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Column(
                                    children: [
                                      Text(
                                        '${totalMembers.length}',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Total Members',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Column(
                                    children: [
                                      Text(
                                        "${orgData['popScore']}",
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        'Popularity Score',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: eventList.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  Event.fromJson(orgData['events'][index])
                                      .eventName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              );
                            }))
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
                                  borderOnForeground: false,
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
                                                              child: const Text(
                                                                  "OK"),
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
                                                              child: const Text(
                                                                  "OK"),
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
                                                    IconButton(
                                                        onPressed:
                                                            showPlacePicker,
                                                        icon: const Icon(
                                                            Icons.create))
                                                  ],
                                                )
                                              : const SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                          const Divider(),
                                          const SizedBox(
                                            height: 25,
                                          ),
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
                                              onPressed: () async {
                                                // this is function for done button
                                                final String id = uuid.v4();
                                                
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

                                                Reference ref = storage
                                                    .ref(title)
                                                    .child(id)
                                                    .child(
                                                        "EventFlyerImage-${_titleTextController.text}");
                                                if (result!.files.single.path !=
                                                    null) {
                                                  UploadTask uploadTask =
                                                      ref.putFile(File(result!
                                                          .files.single.path
                                                          .toString()));
                                                  await uploadTask
                                                      .whenComplete(() async {
                                                    var url = await ref
                                                        .getDownloadURL();
                                                    image_url = url.toString();
                                                  });
                                                }
                                                final event = Event(
                                                    id: id,
                                                    eventName:
                                                        _titleTextController
                                                            .text,
                                                    description:
                                                        _descriptionTextController
                                                            .text,
                                                    flyer: image_url,
                                                    from: startTime,
                                                    to: endTime,
                                                    background: randomColor(),
                                                    address: address,
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                    isAllDay: false);
                                                setState(() async {
                                                  _orgList =
                                                      orgData.putIfAbsent(
                                                          "events", () => null);
                                                  _orgList.add(event.toJson());
                                                  orgDB.update(
                                                      {"events": _orgList});
                                                  setState(() {
                                                    eventList =
                                                        orgData["events"];
                                                  });
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

                                                  setState(() {
                                                    eventList.add(event);
                                                  });
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
    latitude = result.latLng!.latitude;
    longitude = result.latLng!.longitude;
    address = result.formattedAddress.toString();
    setState(() {});
  }
}

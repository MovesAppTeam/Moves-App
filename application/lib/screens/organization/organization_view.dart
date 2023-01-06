import 'dart:io';

import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:application/screens/profile/my_organizations/my_organizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class OrgView extends StatefulWidget {
  const OrgView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<OrgView> createState() => _OrgViewState();
}

class _OrgViewState extends State<OrgView> {
  late Widget okButton;
  late TimeOfDay start;
  late TimeOfDay end;
  late List fileType;
  late String _extension;
  late FileType _pickingType;
  String textValue = 'Public';
  bool isPrivate = false;
  FilePickerResult? result = null;
  late File file;
  late String filePath;
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  bool createOrg = false;
  SampleItem? selectedMenu;
  late String title = widget.title;
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
                                            height: 20,
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
                                                          title: Text(
                                                              "Set start time"),
                                                          actions: [
                                                            okButton =
                                                                TextButton(
                                                              child: Text("OK"),
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
                                                          title: Text(
                                                              "Set end time"),
                                                          actions: [
                                                            okButton =
                                                                TextButton(
                                                              child: Text("OK"),
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
                                                createOrg = !createOrg;
                                                setState(() {
                                                  
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
}

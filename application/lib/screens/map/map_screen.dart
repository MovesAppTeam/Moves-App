import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:application/data_class/events_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:application/reusable_widgets/reusable_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

const LatLng currentLocation = LatLng(25.1193, 55.3773);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Uint8List? _documentBytes;
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
  List eventList = [];
  String panelTitle = "My Schedule";
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    position = _determinePosition();
    super.initState();
  }

  final tempData = FirebaseFirestore.instance
      .collection("userList")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  late Future<Position> position;
  late GoogleMapController _mapController;
  Set<Marker> _markers = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: position,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                final curLocation = snapshot.data;
                return FutureBuilder(
                  future: tempData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final finalData = snapshot.data!.data();
                      eventList = finalData!['events'];
                      eventList.sort();
                      for (String item in eventList) {
                        final Map<String, dynamic> data =
                            JsonDecoder().convert(item);
                        addMarker(
                            data["eventName"],
                            LatLng(data['latitude'], data['longitude']),
                            data['address']);
                        print(_markers);
                      }
                      return Stack(
                        children: [
                          SlidingUpPanel(
                            panel: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Center(
                                      child: Text(
                                    panelTitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: eventList.length,
                                  itemBuilder: ((context, index) {
                                    final Map<String, dynamic> data =
                                        JsonDecoder().convert(eventList[index]);
                                    final Event event =
                                        Event.fromJson(eventList[index]);
                                    final String path = data['flyer'];
                                    final file = File(path);
                                    final fileType = path.split('.');
                                    FirebaseStorage storage =
                                        FirebaseStorage.instance;

                                    return panelTitle != "My Schedule" &&
                                            data['address'] == panelTitle
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  padding:
                                                      MaterialStateProperty.all(
                                                    const EdgeInsets.all(0),
                                                  ),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)))),
                                              onPressed: () {},
                                              child: Container(
                                                  height: 70,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          blurRadius: 10,
                                                        )
                                                      ]),
                                                  child: Stack(children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  20, 8, 8, 8),
                                                          child: Container(
                                                            width: 55,
                                                            height: 55,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                    months[DateTime.fromMillisecondsSinceEpoch(data[
                                                                            'from'])
                                                                        .month],
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(
                                                                    DateTime.fromMillisecondsSinceEpoch(data[
                                                                            'from'])
                                                                        .day
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                Text(
                                                                    days[DateTime.fromMillisecondsSinceEpoch(data[
                                                                            'from'])
                                                                        .weekday],
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      data[
                                                                          'eventName'],
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black54,
                                                                          fontWeight:
                                                                              FontWeight.w800)),
                                                                  data['flyer'] !=
                                                                          ""
                                                                      ? SizedBox(
                                                                          width:
                                                                              180,
                                                                          height:
                                                                              200,
                                                                          child: fileType.last == "pdf"
                                                                              ? SfPdfViewer.memory(_documentBytes!)
                                                                              : Image.network(path))
                                                                      : SizedBox(
                                                                          height:
                                                                              0,
                                                                          width:
                                                                              0,
                                                                        )
                                                                ],
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  ])),
                                            ))
                                        : panelTitle == "My Schedule"
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      padding:
                                                          MaterialStateProperty
                                                              .all(
                                                        const EdgeInsets.all(0),
                                                      ),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)))),
                                                  onPressed: () {},
                                                  child: Container(
                                                      height: 70,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              blurRadius: 10,
                                                            )
                                                          ]),
                                                      child: Stack(children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      20,
                                                                      8,
                                                                      8,
                                                                      8),
                                                              child: Container(
                                                                width: 55,
                                                                height: 55,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                        months[DateTime.fromMillisecondsSinceEpoch(data['from'])
                                                                            .month],
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontWeight: FontWeight.bold)),
                                                                    Text(
                                                                        DateTime.fromMillisecondsSinceEpoch(data['from'])
                                                                            .day
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontWeight: FontWeight.bold)),
                                                                    Text(
                                                                        days[DateTime.fromMillisecondsSinceEpoch(data['from'])
                                                                            .weekday],
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          data[
                                                                              'eventName'],
                                                                          style: const TextStyle(
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.w800)),
                                                                      data['flyer'] !=
                                                                              ""
                                                                          ? SizedBox(
                                                                              width: 180,
                                                                              height: 200,
                                                                              child: fileType.last == "pdf" ? SfPdfViewer.memory(_documentBytes!) : Image.network(path))
                                                                          : SizedBox(
                                                                              height: 0,
                                                                              width: 0,
                                                                            )
                                                                    ],
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ])),
                                                ))
                                            : SizedBox(height: 0, width: 0);
                                  }),
                                )
                              ],
                            ),
                            collapsed: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey, borderRadius: radius),
                              child: Center(
                                child: Text(
                                  panelTitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            body: GoogleMap(
                              onTap: (argument) {
                                if (_markers.any((element) => true)) {
                                  print(argument);
                                  panelTitle = "My Schedule";
                                  setState(() {});
                                }
                              },
                              indoorViewEnabled: true,
                              markers: _markers,
                              onMapCreated: (controller) {
                                controller = _mapController;
                              },
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(curLocation!.latitude,
                                      curLocation!.longitude),
                                  zoom: 14),
                              myLocationButtonEnabled: true,
                              myLocationEnabled: true,
                            ),
                            borderRadius: radius,
                          ),
                        ],
                      );
                    }
                    return Center(child: Text(snapshot.error.toString()));
                  },
                );
              }
            }));
  }

  addMarker(String id, LatLng location, String address) {
    List newList = [];
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(title: address),
      onTap: () {
        panelTitle = address;
        print(eventList);
        setState(() {});
      },
    );

    _markers.add(marker);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

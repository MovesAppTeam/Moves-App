import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:application/reusable_widgets/reusable_widget.dart';

const LatLng currentLocation = LatLng(25.1193, 55.3773);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
                      for (String item in finalData!["events"]) {
                        final Map<String, dynamic> data =
                            JsonDecoder().convert(item);

                        addMarker(data["eventName"],
                            LatLng(data['latitude'], data['longitude']));
                        print(_markers);
                      }
                      return GoogleMap(
                        markers: _markers,
                        onMapCreated: (controller) {
                          controller = _mapController;
                        },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                curLocation!.latitude, curLocation!.longitude),
                            zoom: 14),
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                      );
                    }
                    return Center(child: Text(snapshot.error.toString()));
                  },
                );
              }
            }));
  }

  addMarker(String id, LatLng location) {
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Event {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  String address;
  double latitude;
  double longitude;
  bool isAllDay;
  Event({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isAllDay,
  });

  Event copyWith({
    String? eventName,
    DateTime? from,
    DateTime? to,
    Color? background,
    String? address,
    double? latitude,
    double? longitude,
    bool? isAllDay,
  }) {
    return Event(
      eventName: eventName ?? this.eventName,
      from: from ?? this.from,
      to: to ?? this.to,
      background: background ?? this.background,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'from': from.millisecondsSinceEpoch,
      'to': to.millisecondsSinceEpoch,
      'background': background.value,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'isAllDay': isAllDay,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventName: map['eventName'] ?? '',
      from: DateTime.fromMillisecondsSinceEpoch(map['from']),
      to: DateTime.fromMillisecondsSinceEpoch(map['to']),
      background: Color(map['background']),
      address: map['address'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      isAllDay: map['isAllDay'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Event(eventName: $eventName, from: $from, to: $to, background: $background, address: $address, latitude: $latitude, longitude: $longitude, isAllDay: $isAllDay)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Event &&
      other.eventName == eventName &&
      other.from == from &&
      other.to == to &&
      other.background == background &&
      other.address == address &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.isAllDay == isAllDay;
  }

  @override
  int get hashCode {
    return eventName.hashCode ^
      from.hashCode ^
      to.hashCode ^
      background.hashCode ^
      address.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      isAllDay.hashCode;
  }
}

import 'dart:convert';

import 'package:application/data_class/events_data.dart';
import 'package:collection/collection.dart';

class Organization {
  String id;
  final String imagePath;
  final String name;
  final List adminList;
  final List managerList;
  final List members;
  final List totalMembers;
  final List<Event> events;
  final String privacy;
  final String bio;
  final int popScore;
  Organization({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.adminList,
    required this.managerList,
    required this.members,
    required this.totalMembers,
    required this.events,
    required this.privacy,
    required this.bio,
    required this.popScore,
  });

  Organization copyWith({
    String? id,
    String? imagePath,
    String? name,
    List? adminList,
    List? managerList,
    List? members,
    List? totalMembers,
    List<Event>? events,
    String? privacy,
    String? bio,
    int? popScore,
  }) {
    return Organization(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      adminList: adminList ?? this.adminList,
      managerList: managerList ?? this.managerList,
      members: members ?? this.members,
      totalMembers: totalMembers ?? this.totalMembers,
      events: events ?? this.events,
      privacy: privacy ?? this.privacy,
      bio: bio ?? this.bio,
      popScore: popScore ?? this.popScore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'name': name,
      'adminList': adminList,
      'managerList': managerList,
      'members': members,
      'totalMembers': totalMembers,
      'events': events.map((x) => x.toMap()).toList(),
      'privacy': privacy,
      'bio': bio,
      'popScore': popScore,
    };
  }

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      id: map['id'] ?? '',
      imagePath: map['imagePath'] ?? '',
      name: map['name'] ?? '',
      adminList: List.from(map['adminList']),
      managerList: List.from(map['managerList']),
      members: List.from(map['members']),
      totalMembers: List.from(map['totalMembers']),
      events: List<Event>.from(map['events']?.map((x) => Event.fromMap(x))),
      privacy: map['privacy'] ?? '',
      bio: map['bio'] ?? '',
      popScore: map['popScore']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Organization.fromJson(String source) =>
      Organization.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Organization(id: $id, imagePath: $imagePath, name: $name, adminList: $adminList, managerList: $managerList, members: $members, totalMembers: $totalMembers, events: $events, privacy: $privacy, bio: $bio, popScore: $popScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return other is Organization &&
      other.id == id &&
      other.imagePath == imagePath &&
      other.name == name &&
      listEquals(other.adminList, adminList) &&
      listEquals(other.managerList, managerList) &&
      listEquals(other.members, members) &&
      listEquals(other.totalMembers, totalMembers) &&
      listEquals(other.events, events) &&
      other.privacy == privacy &&
      other.bio == bio &&
      other.popScore == popScore;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      imagePath.hashCode ^
      name.hashCode ^
      adminList.hashCode ^
      managerList.hashCode ^
      members.hashCode ^
      totalMembers.hashCode ^
      events.hashCode ^
      privacy.hashCode ^
      bio.hashCode ^
      popScore.hashCode;
  }
}

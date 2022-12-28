import 'dart:convert';

import 'package:collection/collection.dart';

class Organization {
  final String imagePath;
  final String name;
  final List adminList;
  final List managerList;
  final List members;
  final List totalMembers;
  final String privacy;
  final String bio;
  Organization({
    required this.imagePath,
    required this.name,
    required this.adminList,
    required this.managerList,
    required this.members,
    required this.totalMembers,
    required this.privacy,
    required this.bio,
  });

  Organization copyWith({
    String? imagePath,
    String? name,
    List? adminList,
    List? managerList,
    List? members,
    List? totalMembers,
    String? privacy,
    String? bio,
  }) {
    return Organization(
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      adminList: adminList ?? this.adminList,
      managerList: managerList ?? this.managerList,
      members: members ?? this.members,
      totalMembers: totalMembers ?? this.totalMembers,
      privacy: privacy ?? this.privacy,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'name': name,
      'adminList': adminList,
      'managerList': managerList,
      'members': members,
      'totalMembers': totalMembers,
      'privacy': privacy,
      'bio': bio,
    };
  }

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      imagePath: map['imagePath'] ?? '',
      name: map['name'] ?? '',
      adminList: List.from(map['adminList']),
      managerList: List.from(map['managerList']),
      members: List.from(map['members']),
      totalMembers: List.from(map['totalMembers']),
      privacy: map['privacy'] ?? '',
      bio: map['bio'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Organization.fromJson(String source) => Organization.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Organization(imagePath: $imagePath, name: $name, adminList: $adminList, managerList: $managerList, members: $members, totalMembers: $totalMembers, privacy: $privacy, bio: $bio)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return other is Organization &&
      other.imagePath == imagePath &&
      other.name == name &&
      listEquals(other.adminList, adminList) &&
      listEquals(other.managerList, managerList) &&
      listEquals(other.members, members) &&
      listEquals(other.totalMembers, totalMembers) &&
      other.privacy == privacy &&
      other.bio == bio;
  }

  @override
  int get hashCode {
    return imagePath.hashCode ^
      name.hashCode ^
      adminList.hashCode ^
      managerList.hashCode ^
      members.hashCode ^
      totalMembers.hashCode ^
      privacy.hashCode ^
      bio.hashCode;
  }
}

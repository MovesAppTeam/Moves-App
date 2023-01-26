import 'dart:convert';

import 'package:collection/collection.dart';

class NewUser {
  final String imagePath;
  final String name;
  final String phoneNumber;
  final String email;
  final List myOrgs;
  final List friends;
  final List events;
  final String about;
  final int numFriends;
  final int score;
  final int numOrgs;
  NewUser({
    required this.imagePath,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.myOrgs,
    required this.friends,
    required this.events,
    required this.about,
    required this.numFriends,
    required this.score,
    required this.numOrgs,
  });

  NewUser copyWith({
    String? imagePath,
    String? name,
    String? phoneNumber,
    String? email,
    List? myOrgs,
    List? friends,
    List? events,
    String? about,
    int? numFriends,
    int? score,
    int? numOrgs,
  }) {
    return NewUser(
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      myOrgs: myOrgs ?? this.myOrgs,
      friends: friends ?? this.friends,
      events: events ?? this.events,
      about: about ?? this.about,
      numFriends: numFriends ?? this.numFriends,
      score: score ?? this.score,
      numOrgs: numOrgs ?? this.numOrgs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'myOrgs': myOrgs,
      'friends': friends,
      'events': events,
      'about': about,
      'numFriends': numFriends,
      'score': score,
      'numOrgs': numOrgs,
    };
  }

  factory NewUser.fromMap(Map<String, dynamic> map) {
    return NewUser(
      imagePath: map['imagePath'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      myOrgs: List.from(map['myOrgs']),
      friends: List.from(map['friends']),
      events: List.from(map['events']),
      about: map['about'] ?? '',
      numFriends: map['numFriends']?.toInt() ?? 0,
      score: map['score']?.toInt() ?? 0,
      numOrgs: map['numOrgs']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewUser.fromJson(String source) =>
      NewUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NewUser(imagePath: $imagePath, name: $name, phoneNumber: $phoneNumber, email: $email, myOrgs: $myOrgs, friends: $friends, events: $events, about: $about, numFriends: $numFriends, score: $score, numOrgs: $numOrgs)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return other is NewUser &&
      other.imagePath == imagePath &&
      other.name == name &&
      other.phoneNumber == phoneNumber &&
      other.email == email &&
      listEquals(other.myOrgs, myOrgs) &&
      listEquals(other.friends, friends) &&
      listEquals(other.events, events) &&
      other.about == about &&
      other.numFriends == numFriends &&
      other.score == score &&
      other.numOrgs == numOrgs;
  }

  @override
  int get hashCode {
    return imagePath.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      email.hashCode ^
      myOrgs.hashCode ^
      friends.hashCode ^
      events.hashCode ^
      about.hashCode ^
      numFriends.hashCode ^
      score.hashCode ^
      numOrgs.hashCode;
  }
}

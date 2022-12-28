import 'dart:convert';

import 'package:collection/collection.dart';

class NewUser {
  final String imagePath;
  final String name;
  final String phoneNumber;
  final String email;
  final List myOrgs;
  final String about;
  NewUser({
    required this.imagePath,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.myOrgs,
    required this.about,
  });

  NewUser copyWith({
    String? imagePath,
    String? name,
    String? phoneNumber,
    String? email,
    List? myOrgs,
    String? about,
  }) {
    return NewUser(
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      myOrgs: myOrgs ?? this.myOrgs,
      about: about ?? this.about,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'myOrgs': myOrgs,
      'about': about,
    };
  }

  factory NewUser.fromMap(Map<String, dynamic> map) {
    return NewUser(
      imagePath: map['imagePath'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      myOrgs: List.from(map['myOrgs']),
      about: map['about'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NewUser.fromJson(String source) => NewUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NewUser(imagePath: $imagePath, name: $name, phoneNumber: $phoneNumber, email: $email, myOrgs: $myOrgs, about: $about)';
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
      other.about == about;
  }

  @override
  int get hashCode {
    return imagePath.hashCode ^
      name.hashCode ^
      phoneNumber.hashCode ^
      email.hashCode ^
      myOrgs.hashCode ^
      about.hashCode;
  }
}
